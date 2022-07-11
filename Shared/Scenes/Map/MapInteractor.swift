//
//  MapInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/14.
//

import Foundation

protocol MapUsecase {
//    func getProfile(id: String, completion: ((Result<Profile?, Error>) -> Void)?)
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?)
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?)
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?)
    func addLocationListener(ownerId: String, completion: ((Result<[Location]?, Error>) -> Void)?)
    func removeLocationListener()
    func addImadokoMessageListener(ownerId: String, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?)
    func removeImadokoMessageListener()
    func addProfileListener(id: String, completion: ((Result<Profile?, Error>) -> Void)?)
    func removeProfileListener()
}

final class MapInteractor {
    private let imadokoMessageStore: ImadokoMessageStore
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    private let notificationStore: NotificationStore
    private let locationStore: LocationStore
    
    init() {
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
        self.notificationStore = NotificationStore()
        self.locationStore = LocationStore()
        self.imadokoMessageStore = ImadokoMessageStore()
    }
}

extension MapInteractor: MapUsecase {
//    func getProfile(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
//        self.profileStore.getDocument(id: id, completion: completion)
//    }
    
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?) {
        self.profileStore.getDocuments(ids: ids, completion: completion)
    }
    
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?) {
        self.avatarImageStore.getDocument(id: id, completion: completion)
    }
    
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?) {
        self.avatarImageStore.getDocuments(ids: ids, completion: completion)
    }
    
    func addLocationListener(ownerId: String, completion: ((Result<[Location]?, Error>) -> Void)?) {
        self.locationStore.addListener(ownerId: ownerId, overwrite: false, completion: completion)
    }
    
    func removeLocationListener() {
        self.locationStore.removeListener()
    }
    
    func addImadokoMessageListener(ownerId: String, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?) {
        self.imadokoMessageStore.addListener(ownerId: ownerId, completion: completion)
    }
    
    func removeImadokoMessageListener() {
        self.imadokoMessageStore.removeListener()
    }
    
    func addProfileListener(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
        self.profileStore.addListener(id: id, overwrite: false, completion: completion)
    }
    
    func removeProfileListener() {
        self.profileStore.removeListener()
    }
}
