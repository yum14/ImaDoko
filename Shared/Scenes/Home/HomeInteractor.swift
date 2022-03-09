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
    func updateFriendsOfProfile(id: String, friends: [String], completion: ((Error?) -> Void)?)
    func updateAvatarImage(id: String, imageData: Data, completion: ((Error?) -> Void)?)
}

final class HomeInteractor {
    private let profileStore: ProfileStore
    
    init() {
        self.profileStore = ProfileStore()
    }
}

extension HomeInteractor: HomeUsecase {
    func updateNameOfProfile(id: String, name: String, completion: ((Error?) -> Void)?) {
        self.profileStore.updateName(id: id, name: name, completion: completion)
    }
    
    func addProfileListener(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
        self.profileStore.addListener(id: id, completion: completion)
    }
    
    func removeProfileListener() {
        self.profileStore.removeListener()
    }
    
    func updateFriendsOfProfile(id: String, friends: [String], completion: ((Error?) -> Void)?) {
        self.profileStore.updateFriends(id: id, friends: friends, completion: completion)
    }
    
    func updateAvatarImage(id: String, imageData: Data, completion: ((Error?) -> Void)?) {
        self.profileStore.updateAvatarImage(id: id, imageData: imageData, completion: completion)
    }
}
