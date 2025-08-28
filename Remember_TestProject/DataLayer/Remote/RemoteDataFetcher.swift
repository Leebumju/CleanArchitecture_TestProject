//
//  RemoteDataFetcher.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

final class RemoteDataFetcher: RemoteDataFetchable {
    private let networkWrapper: NetworkWrapper = NetworkWrapper.shared
    
    func searchUsers(with request: GitHubUserRequest) async throws -> GitHubUserResponse {
        do {
            let response = try await networkWrapper.fetchPublicService(.searchUsers(request: request))
            
            guard let decodedResponse = try DecodeUtil.decode(GitHubUserResponse.self,
                                                              data: response.data) else {
                throw NetworkError.typeMismatch
            }

            return decodedResponse
        } catch {
            print(error)
            throw error
        }
    }
}
