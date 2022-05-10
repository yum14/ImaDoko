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
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?)
    func addMyLocationsListener(id: String, completion: ((Result<MyLocations?, Error>) -> Void)?)
    func removeMyLocationsListener()
}

final class MapInteractor {
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    private let notificationStore: NotificationStore
    private let myLocationsStore: MyLocationsStore
    
    init() {
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
        self.notificationStore = NotificationStore()
        self.myLocationsStore = MyLocationsStore()
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
    
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?) {
        self.avatarImageStore.getDocuments(ids: ids, completion: completion)
    }
    
    func addMyLocationsListener(id: String, completion: ((Result<MyLocations?, Error>) -> Void)?) {
        self.myLocationsStore.addListener(id: id, overwrite: false, completion: completion)
    }
    
    func removeMyLocationsListener() {
        self.myLocationsStore.removeListener()
    }
}
