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
    func setImakokoNotification(_ data: ImakokoNotification, completion: ((Error?) -> Void)?)
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?)
    func addMyLocationsListener(id: String, completion: ((Result<MyLocations?, Error>) -> Void)?)
    func removeMyLocationsListener()
    func appendImadokoMessages(_ data: ImadokoMessage, id: String, completion: ((Error?) -> Void)?)
}

final class MapInteractor {
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    private let imakokoNotificationStore: ImakokoNotificationStore
    private let myLocationsStore: MyLocationsStore
    private let imadokoMessagesStore: ImadokoMessagesStore
    
    init() {
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
        self.imakokoNotificationStore = ImakokoNotificationStore()
        self.myLocationsStore = MyLocationsStore()
        self.imadokoMessagesStore = ImadokoMessagesStore()
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
    
    func setImakokoNotification(_ data: ImakokoNotification, completion: ((Error?) -> Void)?) {
        self.imakokoNotificationStore.setData(data, completion: completion)
    }
    
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?) {
        self.myLocationsStore.appendLocation(data, id: id, completion: completion)
    }
    
    func addMyLocationsListener(id: String, completion: ((Result<MyLocations?, Error>) -> Void)?) {
        self.myLocationsStore.addListener(id: id, overwrite: false, completion: completion)
    }
    
    func removeMyLocationsListener() {
        self.myLocationsStore.removeListener()
    }
    
    func appendImadokoMessages(_ data: ImadokoMessage, id: String, completion: ((Error?) -> Void)?) {
        self.imadokoMessagesStore.appendImadokoMessage(data, id: id, completion: completion)
    }
}
