//
//  temp2.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation

struct GitHubUserResponse: Decodable {
    let totalCount: Int?
    let items: [GitHubUser]?
}

struct GitHubUser: Decodable {
    let id: Int?
    let login: String?
    let avatarURL: String?
}
