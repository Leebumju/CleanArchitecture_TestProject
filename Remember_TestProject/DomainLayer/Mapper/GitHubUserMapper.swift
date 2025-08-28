//
//  UserMapper.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

struct GitHubUserMapper {
    // Remote
    static func gitHubUserResponsetoEntity(_ response: GitHubUserResponse) -> [GitHubUserEntity] {
        guard let users = response.items else { return [] }
        return users.map { user in
            GitHubUserEntity(
                id: user.id ?? 0,
                login: user.login ?? "",
                avatarUrl: user.avatarUrl ?? "",
                isFavorite: false
            )
        }
    }
    
    // Local
    static func gitHubUserObjectToEntity(_ objects: [GitHubUserObject]) -> [GitHubUserEntity] {
        return objects.map { object in
            GitHubUserEntity(
                id: object.id,
                login: object.login,
                avatarUrl: object.avatarUrl,
                isFavorite: true
            )
        }
    }
}
