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
    func addLocationListener(ownerId: String, completion: ((Result<[Location]?, Error>) -> Void)?)
    func removeLocationListener()
}

final class MapInteractor {
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    private let notificationStore: NotificationStore
    private let locationStore: LocationStore
    
    init() {
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
        self.notificationStore = NotificationStore()
        self.locationStore = LocationStore()
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
    
    func addLocationListener(ownerId: String, completion: ((Result<[Location]?, Error>) -> Void)?) {
        self.locationStore.addListener(ownerId: ownerId, overwrite: false, completion: completion)
    }
    
    func removeLocationListener() {
        self.locationStore.removeListener()
    }
}
