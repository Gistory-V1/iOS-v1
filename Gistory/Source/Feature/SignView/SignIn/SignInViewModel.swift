import Foundation
import Combine

public class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var emailErrorMessage: String? = nil
    @Published var passwordErrorMessage: String? = nil
    @Published var successMessage: String? = nil
    @Published var name: String? = nil // 이름 추가
    
    
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
                    // 로그인 실패 시 이메일 오류 메시지 표시
                    self?.passwordErrorMessage = "비밀번호가 틀렸습니다."
                    print("로그인 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                self?.emailErrorMessage = nil // 이메일 오류 초기화
                self?.successMessage = response.message  // 로그인 성공 시 성공 메시지 처리
                self?.name = response.name 
                self?.handleTokens(response)
                // 서버 응답 출력
                print("로그인 상태: \(response.message)")
//                print("액세스 토큰: \(response.accessToken)")
//                print("리프레시 토큰: \(response.refreshToken)")
//                print("액세스 토큰 만료 시간: \(response.accessTokenExpiresIn)")
//                print("리프레시 토큰 만료 시간: \(response.refreshTokenExpiresIn)")
                print("이름: \(response.name)")
            })
            .store(in: &cancellables)
    }
    // 이메일 검증 함수
    public func validateEmail() -> Bool {
        if email.isEmpty {
            emailErrorMessage = "이메일을 입력해주세요."
            print("이메일 오류: 이메일을 입력해주세요.")  // 에러 메시지 출력
            return false
        } else if !isValidEmail(email) {
            emailErrorMessage = "올바른 이메일 형식이 아닙니다."
            print("이메일 오류: 올바른 이메일 형식이 아닙니다.")  // 에러 메시지 출력
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
    public func saveTokenToKeychain(key: String, value: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value.data(using: .utf8)!
        ]
        
        SecItemDelete(query as CFDictionary) // 기존 값을 삭제
        let status = SecItemAdd(query as CFDictionary, nil) // 새 값을 추가
        
        if status == errSecSuccess {
            print("\(key) 저장 성공: \(value)")
        } else {
            print("\(key) 저장 실패, 상태 코드: \(status)")
        }
    }
}

public struct SignInResponse: Codable {
    public let message: String
    public let accessToken: String
    public let refreshToken: String
    public let accessTokenExpiresIn: String
    public let refreshTokenExpiresIn: String
    public let name: String // 이름 추가

    public init(message: String, accessToken: String, refreshToken: String, accessTokenExpiresIn: String, refreshTokenExpiresIn: String, name: String) {
        self.message = message
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.accessTokenExpiresIn = accessTokenExpiresIn
        self.refreshTokenExpiresIn = refreshTokenExpiresIn
        self.name = name
    }
}

