//
//  NetworkService.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Moya

enum NetworkService {
    case searchUsers(query: String)
}

extension NetworkService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .searchUsers(let query):
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
         case .searchUsers(let query):
             let parameters = ["q": "\(query) in:name"]
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
