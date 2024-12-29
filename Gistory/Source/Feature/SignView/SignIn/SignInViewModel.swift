import Foundation
import Combine

public class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var emailErrorMessage: String? = nil
    @Published var passwordErrorMessage: String? = nil
    @Published var successMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let loginURL = "https://port-0-gistory-server-v1-m47qofx19aae55ab.sel4.cloudtype.app/auth/login"
    
    public func signIn() {
        // 이메일 및 비밀번호 유효성 검사
        guard validateEmail(), validatePassword() else {
            return
        }
        
        guard let url = URL(string: loginURL) else {
            emailErrorMessage = "잘못된 URL입니다."
            return
        }
        
        let requestBody: [String: String] = [
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            emailErrorMessage = "요청 데이터를 인코딩할 수 없습니다."
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        isLoading = true
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                if let httpResponse = output.response as? HTTPURLResponse {
                    if !(200...299).contains(httpResponse.statusCode) {
                        let errorMessage = String(data: output.data, encoding: .utf8) ?? "서버 오류"
                        throw URLError(.init(rawValue: httpResponse.statusCode), userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    }
                }
                return output.data
            }
            .decode(type: SignInResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.emailErrorMessage = "로그인 실패: \(error.localizedDescription)"
                    print("로그인 실패: \(error.localizedDescription)") // 로그인 실패 메시지 출력
                }
            }, receiveValue: { [weak self] response in
                self?.successMessage = response.message
                self?.emailErrorMessage = nil
                self?.passwordErrorMessage = nil
                self?.handleTokens(response)
                print("로그인 성공: \(response.message)") // 로그인 성공 메시지 출력
            })
            .store(in: &cancellables)
    }
    
    // 이메일 검증 함수
    public func validateEmail() -> Bool {
        if email.isEmpty {
            emailErrorMessage = "이메일을 입력해주세요."
            return false
        } else if !isValidEmail(email) {
            emailErrorMessage = "올바른 이메일 형식이 아닙니다."
            return false
        } else {
            emailErrorMessage = nil
            return true
        }
    }
    
    // 비밀번호 검증 함수
    public func validatePassword() -> Bool {
        if password.isEmpty {
            passwordErrorMessage = "비밀번호를 입력해주세요."
            return false
        } else if password.count < 8 {
            passwordErrorMessage = "비밀번호는 8자 이상이어야 합니다."
            return false
//        } else if !password.contains(where: { "!@#$%^&*".contains($0) }) {
//            passwordErrorMessage = "비밀번호에 특수문자가 포함되어야 합니다."
//            return false
//        }
        } else {
            passwordErrorMessage = nil
            return true
        }
    }
    
    // 이메일 유효성 검사
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^s\\d{5}@gsm\\.hs\\.kr$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // 토큰 처리 함수
    public func handleTokens(_ response: SignInResponse) {
        saveTokenToKeychain(key: "accessToken", value: response.accessToken)
        saveTokenToKeychain(key: "refreshToken", value: response.refreshToken)
        saveTokenToKeychain(key: "accessTokenExpiresIn", value: response.accessTokenExpiresIn)
        saveTokenToKeychain(key: "refreshTokenExpiresIn", value: response.refreshTokenExpiresIn)
    }
    
    // Keychain 저장 함수
    private func saveTokenToKeychain(key: String, value: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value.data(using: .utf8)!
        ]
        SecItemDelete(query as CFDictionary) // 기존 값 제거
        SecItemAdd(query as CFDictionary, nil)
    }
}

public struct SignInResponse: Codable {
    public let message: String
    public let accessToken: String
    public let refreshToken: String
    public let accessTokenExpiresIn: String
    public let refreshTokenExpiresIn: String
    
    public init(message: String, accessToken: String, refreshToken: String, accessTokenExpiresIn: String, refreshTokenExpiresIn: String) {
        self.message = message
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.accessTokenExpiresIn = accessTokenExpiresIn
        self.refreshTokenExpiresIn = refreshTokenExpiresIn
    }
}

