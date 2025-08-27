//
//  LocalDataFetcher.swift
//  Remember_TestProject
//
//  Created by 이범준 on 8/27/25.
//

import Foundation
import Combine
import RealmSwift

final class LocalDataFetcher: LocalDataFetchable {
    private let realm: Realm?

    init() {
        do {
            realm = try Realm()
        } catch {
            print("Realm 초기화 실패: \(error)")
            realm = nil
        }
    }

    func save(_ user: GitHubUserEntity) throws {
        guard let realm = realm else { throw LocalDataError.realmUnavailable }
        let object = GitHubUserObject(from: user)
        do {
            try realm.write { realm.add(object, update: .modified) }
        } catch {
            throw error
        }
    }

    func delete(_ user: GitHubUserEntity) throws {
        guard let realm = realm else { throw LocalDataError.realmUnavailable }
        guard let object = realm.object(ofType: GitHubUserObject.self, forPrimaryKey: user.id) else { return }
        do {
            try realm.write { realm.delete(object) }
        } catch {
            throw error
        }
    }

    func fetchFavoriteUsers() -> [GitHubUserEntity] {
        guard let realm = realm else { return [] }
        let objects = realm.objects(GitHubUserObject.self)
        return GitHubUserMapper.gitHubUserObjectToEntity(Array(objects))
    }
}

enum LocalDataError: Error {
    case realmUnavailable
}
