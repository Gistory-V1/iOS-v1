import SwiftUI

struct SignUpFeature: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SIGN UP")
                .font(.system(size: 32))
                .fontWeight(.semibold)
            
            GtTextField(
                "학교 이메일을 입력해주세요",
                text: $viewModel.email,
                bigtitle: "이메일",
                errorText: viewModel.isValidEmail(viewModel.email) ? "" : "올바른 이메일 형식이 아닙니다.",
                isError: !viewModel.isValidEmail(viewModel.email)
            )
            
            // 비밀번호 입력 필드
            GtTextField(
                "8자 이상 입력해주세요",
                text: $viewModel.password,
                bigtitle: "비밀번호",
                errorText: viewModel.isValidPassword(viewModel.password) ? "" : "비밀번호는 8자 이상이어야 합니다.",
                isError: !viewModel.isValidPassword(viewModel.password),
                isSecure: true
            )
            
           GtTextField(
            "비밀번호를 재입력 해주세요",
            text: $viewModel.confirmPassword,
            bigtitle: "비밀번호 확인",
            errorText: viewModel.passwordMatchError ?? "",
            isError: viewModel.passwordMatchError != nil,
            isSecure: true
            )

            Spacer()
            
            // 회원가입 버튼
            Button(action: {
                viewModel.signUp()
            }) {
                Text("회원가입")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.isSignUpValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!viewModel.isSignUpValid) // 유효성에 따라 버튼 비활성화
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
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
}

#Preview {
    SignUpFeature()
}

