//
//  HomeInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/01.
//

import Foundation

protocol HomeUsecase {
    func updateNameOfProfile(id: String, name: String, completion: ((Error?) -> Void)?)
    func addProfileListener(id: String, completion: ((Result<Profile?, Error>) -> Void)?)
    func removeProfileListener()
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?)
    func updateFriendsOfProfile(id: String, friends: [String], completion: ((Error?) -> Void)?)
    func setAvatarImage(_ data: AvatarImage, completion: ((Error?) -> Void)?)
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?)
}

final class HomeInteractor {
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    private let notificationTokenStore: NotificationTokenStore
    
    init() {
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
        self.notificationTokenStore = NotificationTokenStore()
    }
}

extension HomeInteractor: HomeUsecase {
    func updateNameOfProfile(id: String, name: String, completion: ((Error?) -> Void)?) {
        self.profileStore.updateName(id: id, name: name, completion: completion)
    }
    
    func addProfileListener(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
        // 初回のみlistenerを設定する
        self.profileStore.addListener(id: id, overwrite: false, completion: completion)
    }
    
    func removeProfileListener() {
        self.profileStore.removeListener()
    }
    
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?) {
        self.profileStore.getDocuments(ids: ids, completion: completion)
    }
    
    func updateFriendsOfProfile(id: String, friends: [String], completion: ((Error?) -> Void)?) {
        self.profileStore.updateFriends(id: id, friends: friends, completion: completion)
    }
    
    func setAvatarImage(_ data: AvatarImage, completion: ((Error?) -> Void)?) {
        self.avatarImageStore.setData(data, completion: completion)
    }
    
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?) {
        self.avatarImageStore.getDocument(id: id, completion: completion)
    }
}
