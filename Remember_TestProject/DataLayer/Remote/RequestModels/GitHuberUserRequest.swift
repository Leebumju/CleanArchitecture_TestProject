//
//  GitHuberUserRequest.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/28/25.
//

import Foundation

struct GitHubUserRequest {
    let query: String
    let page: Int
    let perPage: Int

    init(query: String, page: Int = 1, perPage: Int = 30) {
        self.query = query
        self.page = page
        self.perPage = perPage
    }

    var queryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
    }
}
