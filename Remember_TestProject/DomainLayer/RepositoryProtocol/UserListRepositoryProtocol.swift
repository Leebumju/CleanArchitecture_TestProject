//
//  temp3.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

protocol UserListRepositoryProtocol: AnyObject {
    func searchUsers(with query: String) async throws -> [GitHubUserEntity]
}
