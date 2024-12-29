import SwiftUI

struct SignInFeature: View {
    @StateObject private var viewModel = SignInViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("LOGIN")
                .font(.system(size: 32))
                .fontWeight(.semibold)
            
            // 이메일 입력 필드
            GtTextField(
                "학교 이메일을 입력해주세요",
                text: $viewModel.email,
                bigtitle: "이메일",
                errorText: viewModel.emailErrorMessage ?? "",
                isError: !(viewModel.emailErrorMessage?.isEmpty ?? true)
            )
            .onSubmit {
                viewModel.validateEmail()
            }

            GtTextField(
                "특수문자 포함 8자 이상 입력해주세요",
                text: $viewModel.password,
                bigtitle: "비밀번호",
                errorText: viewModel.passwordErrorMessage ?? "",
                isError: !(viewModel.passwordErrorMessage?.isEmpty ?? true),
                isSecure: true
            )
            .onSubmit {
                viewModel.validatePassword()
            }
            
            
            Spacer()
            
            // 로그인 버튼
            Button(action: {
                viewModel.signIn()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                } else {
                    Text("로그인")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(viewModel.email.isEmpty || viewModel.password.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
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
    SignInFeature()
}

