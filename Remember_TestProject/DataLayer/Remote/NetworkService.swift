//
//  NetworkService.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Moya

enum NetworkService {
    case searchUsers(request: GitHubUserRequest)
}

extension NetworkService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.gitub.com")!
    }
    
    var path: String {
        switch self {
        case .searchUsers(_):
            return "/search/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchUsers:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchUsers(let request):
            let parameters: [String: Any] = [
                "q": "\(request.query) in:login",
                "page": request.page,
                "per_page": request.perPage
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization": ""]
    }
    
    var contentType: String {
        return "application/json"
    }
}

enum NetworkError: LocalizedError {
    case typeMismatch
    case unknownError
    case emptyToken
    case emptyData
}
