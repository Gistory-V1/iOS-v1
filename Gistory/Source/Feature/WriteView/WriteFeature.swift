import SwiftUI
import Moya

struct WriteFeature: View {
    @StateObject var viewModel = WriteViewModel()
    
    private let provider = MoyaProvider<PostAPI>()
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                viewModel.sendDataToServer()
            } label: {
                Text("완료")
                    .fontWeight(.light)
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 0.5)
                            .opacity(0.5)
                    )
            }
            .padding(.leading, 250)
            
            Divider()
            
            TextField("제목", text: $viewModel.title)
                .frame(width: 345)
                .font(.system(size: 24))
            
            TextField("내용을 입력해 주세요", text: $viewModel.content)
                .frame(width: 345)
                .font(.system(size: 16))
            
            if !viewModel.successMessage.isEmpty {
                Text(viewModel.successMessage)
                    .foregroundColor(.green)
            }
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WriteFeature()
}

