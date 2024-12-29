import Foundation
import Combine

public class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = "" // 비밀번호 재입력 필드
    @Published var serverMessage: String? = nil
    @Published var isSignUpValid: Bool = false
    @Published var passwordMatchError: String? = nil // 비밀번호 불일치 메시지
    
    private var cancellables = Set<AnyCancellable>()
    private let signUpURL = "https://port-0-gistory-server-v1-m47qofx19aae55ab.sel4.cloudtype.app/auth/signup"
    
    init() {
        // 이메일, 비밀번호, 비밀번호 확인의 유효성 검사
        $email.combineLatest($password, $confirmPassword)
            .map { email, password, confirmPassword in
                let isEmailValid = self.isValidEmail(email)
                let isPasswordValid = self.isValidPassword(password)
                let arePasswordsMatching = password == confirmPassword
                
                // 비밀번호 불일치 시 메시지 설정
                self.passwordMatchError = arePasswordsMatching ? nil : "비밀번호가 일치하지 않습니다."
                
                return isEmailValid && isPasswordValid && arePasswordsMatching
            }
            .assign(to: &$isSignUpValid)
    }
    
    public func signUp() {
        guard let url = URL(string: signUpURL) else {
            serverMessage = "잘못된 URL입니다."
            return
        }
        
        let requestBody: [String: String] = [
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            serverMessage = "요청 데이터를 인코딩할 수 없습니다."
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                if let httpResponse = output.response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: SignUpResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.serverMessage = "회원가입 실패: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                self.serverMessage = response.message
            })
            .store(in: &cancellables)
    }
    
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^s\\d{5}@gsm\\.hs\\.kr$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 // 비밀번호 최소 길이 검사
    }
}

struct SignUpResponse: Codable {
    let message: String
}

