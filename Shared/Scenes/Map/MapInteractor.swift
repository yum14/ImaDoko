//
//  MapInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/14.
//

import Foundation

protocol MapUsecase {
    func getProfile(id: String, completion: ((Result<Profile?, Error>) -> Void)?)
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?)
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?)
}

final class MapInteractor {
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    
    init() {
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
    }
}

extension MapInteractor: MapUsecase {
    func getProfile(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
        self.profileStore.getDocument(id: id, completion: completion)
    }
    
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?) {
        self.profileStore.getDocuments(ids: ids, completion: completion)
    }
    
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?) {
        self.avatarImageStore.getDocument(id: id, completion: completion)
    }
}
