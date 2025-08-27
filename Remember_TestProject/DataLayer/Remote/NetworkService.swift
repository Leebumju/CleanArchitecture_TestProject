//
//  NetworkService.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Moya

enum NetworkService {
   
}

extension NetworkService: TargetType {
    var baseURL: URL {
        switch self {
        }
    }
    
    var path: String {
        switch self {
        }
    }
    
    var method: Moya.Method {
        switch self {
        
        }
    }
    
    var task: Moya.Task {
        switch self {
        
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization": ""]
    }
    
    var contentType: String {
        return "application/json"
    }
}
