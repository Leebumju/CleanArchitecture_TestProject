//
//  temp.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import RealmSwift

class GitHubUserObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var login: String
    @Persisted var avatarURL: String

    convenience init(from entity: GitHubUserEntity) {
        self.init()
        self.id = entity.id
        self.login = entity.login
        self.avatarURL = entity.avatarURL
    }
}
