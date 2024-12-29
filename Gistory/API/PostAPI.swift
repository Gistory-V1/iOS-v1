import Foundation
import Moya

public enum PostAPI {
    case createPost(sessionId: String, title: String, content: String)
}

extension PostAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://port-0-gistory-server-v1-m47qofx19aae55ab.sel4.cloudtype.app")!
    }
    
    public var path: String {
        switch self {
        case .createPost:
            return "/api/post/create"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        switch self {
        case .createPost(let sessionId, let title, let content):
            let parameters: [String: Any] = [
                "header": [
                    "sessionId": sessionId
                ],
                "body": [
                    "title": title,
                    "content": content
                ]
            ]
            print("Request Parameters: \(parameters)")
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}


