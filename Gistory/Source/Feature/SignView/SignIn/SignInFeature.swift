//
//  SignInFeature.swift
//  Gistory
//
//  Created by 박정우 on 12/17/24.
//

import SwiftUI

struct SignInFeature: View {
    @State private var SignInEmail: String = ""
    @State private var SignPassword: String = ""
    @State private var showEmailError: Bool = false
    @State private var emailErrorMessage: String = ""
    @State private var showPasswordError: Bool = false
    @State private var passwordErrorMessage: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SIGN IN")
                .font(.system(size: 32))
                .fontWeight(.semibold)
            GtTextField(
                "학교 이메일을 입력해주세요",
                text: $SignInEmail,
                bigtitle: "이메일",
                errorText: emailErrorMessage,
                isError: showEmailError,
                onSubmit: {
                    validateEmail()
                }
            )
            GtTextField(
                "특수문자 포함 12자 이내로 입력해주세요",
                text: $SignPassword,
                bigtitle: "비밀번호",
                errorText: passwordErrorMessage,
                isError: showPasswordError,
                isSecure: true
//                onSubmit: {
//                    validatePassword()
//                }
                
            )
        }
        .padding(.bottom, 400)
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 10, height: 20)
                    .padding(.leading, 15)
                    .foregroundColor(.black)
        })
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^s\\d{5}@gsm\\.hs\\.kr$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validateEmail() {
        if SignInEmail.isEmpty {
            emailErrorMessage = "이메일을 입력해주세요"
            showEmailError = true
        } else if !isValidEmail(SignInEmail) {
            emailErrorMessage = "올바른 이메일 형식이 아닙니다."
            showEmailError = true
        } else {
            emailErrorMessage = ""
            showEmailError = false
        }
    }
}

#Preview {
    SignInFeature()
}
