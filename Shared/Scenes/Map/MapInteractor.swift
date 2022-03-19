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
    func setImakokoNotification(_ data: ImakokoNotification, completion: ((Error?) -> Void)?)
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?)
}

final class MapInteractor {
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    private let imakokoNotificationStore: ImakokoNotificationStore
    private let myLocationStore: MyLocationsStore
    
    init() {
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
        self.imakokoNotificationStore = ImakokoNotificationStore()
        self.myLocationStore = MyLocationsStore()
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
    
    func setImakokoNotification(_ data: ImakokoNotification, completion: ((Error?) -> Void)?) {
        self.imakokoNotificationStore.setData(data, completion: completion)
    }
    
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?) {
        self.myLocationStore.appendLocation(data, id: id, completion: completion)
    }
}
