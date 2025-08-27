//
//  UserMapper.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

struct GitHubUserMapper {
    static func gitHubUsertoEntity(_ response: GitHubUserResponse) -> [GitHubUserEntity] {
        guard let users = response.items else { return [] }
        return users.map { user in
            GitHubUserEntity(
                id: user.id ?? 0,
                login: user.login ?? "",
                avatarURL: user.avatarURL ?? "",
                isFavorite: false
            )
        }
    }
}
