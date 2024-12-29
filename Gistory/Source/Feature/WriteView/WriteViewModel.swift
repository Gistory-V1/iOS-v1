//
//  WriteViewModel.swift
//  Gistory
//
//  Created by 박정우 on 12/23/24.
//

import Foundation
import Moya

public final class WriteViewModel: ObservableObject {
    private  let provider = MoyaProvider<PostAPI>()
    
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var sessionId: String = ""
    @Published var successMessage: String = ""
    @Published var errorMessage: String = ""

    public func sendDataToServer() {
        successMessage = ""
        errorMessage = ""

        provider.request(.createPost(sessionId: sessionId, title: title, content: content)) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    if response.statusCode == 201 {
                        self.successMessage = "글 작성 성공!"
                        self.title = ""
                        self.content = ""
                    } else {
                        self.errorMessage = "오류 발생: \(response.statusCode)"
                    }
                case .failure(let error):
                    self.errorMessage = "요청 실패: \(error.localizedDescription)"
                }
            }
        }
    }
}
