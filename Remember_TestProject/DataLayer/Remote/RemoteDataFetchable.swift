//
//  RemoteDataFetchable.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation

protocol RemoteDataFetchable: AnyObject {
    func searchUsers(with request: GitHubUserRequest) async throws -> GitHubUserResponse
}
