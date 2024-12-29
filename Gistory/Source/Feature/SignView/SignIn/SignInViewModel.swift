import Foundation
import SwiftUI

public class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showEmailError: Bool = false
    @Published var emailErrorMessage: String = ""
    @Published var showPasswordError: Bool = false
    @Published var passwordErrorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^s\\d{5}@gsm\\.hs\\.kr$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{1,12}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    public func validateEmail() {
        if email.isEmpty {
            emailErrorMessage = "이메일을 입력해주세요"
            showEmailError = true
        } else if !isValidEmail(email) {
            emailErrorMessage = "올바른 이메일 형식이 아닙니다."
            showEmailError = true
        } else {
            emailErrorMessage = ""
            showEmailError = false
        }
    }
    
    public func validatePassword() {
        if password.isEmpty {
            passwordErrorMessage = "비밀번호를 입력해주세요"
            showPasswordError = true
        } else if !isValidPassword(password) {
            passwordErrorMessage = "비밀번호 형식이 올바르지 않습니다."
            showPasswordError = true
        } else {
            passwordErrorMessage = ""
            showPasswordError = false
        }
    }
    
   public func handleSignUp() {
        validateEmail()
        validatePassword()
        
        guard !showEmailError, !showPasswordError else { return }
        
        let requestBody: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        guard let url = URL(string: "https://api.example.com/signup") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            alertMessage = "요청 생성 중 오류 발생"
            showAlert = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessage = "오류 발생: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    self.alertMessage = "회원가입 성공!"
                } else {
                    self.alertMessage = "회원가입 실패. 다시 시도해주세요."
                }
                self.showAlert = true
            }
        }.resume()
    }
}
