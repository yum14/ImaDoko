//
//  MapInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/14.
//

import Foundation

protocol MapUsecase {
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?)
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?)
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?)
    func addLocationListenerForAdditionalData(ownerId: String, isGreaterThan: Date, completion: ((Result<[Location]?, Error>) -> Void)?)
    func removeLocationListener()
    func addImadokoMessageListenerOnNotReplyedAndUnRead(toId: String, isGreaterThan: Date, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?)
    func addImadokoMessageListenerOnNotReplyed(toId: String, isGreaterThan: Date, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?)
    func addKokodayoMessageListenerForAdditionalData(toId: String, isGreaterThan: Date, completion: ((Result<[KokodayoMessage], Error>) -> Void)?)
    func removeImadokoMessageListener()
    func removeKokodayoMessageListener()
    func addProfileListener(id: String, completion: ((Result<Profile?, Error>) -> Void)?)
    func removeProfileListener()
    func addLocations(locations: [Location], completion: ((Error?) -> Void)?)
    func updateKokodayoMessageToAlreadyRead(ids: [String], completion: ((Error?) -> Void)?)
    func updateImadokoMessageToAlreadyRead(ids: [String], completion: ((Error?) -> Void)?)
}

final class MapInteractor {
    private let imadokoMessageStore: ImadokoMessageStore
    private let kokodayoMessageStore: KokodayoMessageStore
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
        self.kokodayoMessageStore = KokodayoMessageStore()
    }
}

extension MapInteractor: MapUsecase {
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?) {
        self.profileStore.getDocuments(ids: ids, completion: completion)
    }
    
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?) {
        self.avatarImageStore.getDocument(id: id, completion: completion)
    }
    
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?) {
        self.avatarImageStore.getDocuments(ids: ids, completion: completion)
    }
    
    func addLocationListenerForAdditionalData(ownerId: String, isGreaterThan: Date, completion: ((Result<[Location]?, Error>) -> Void)?) {
        self.locationStore.addListenerForAdditionalData(ownerId: ownerId, isGreaterThan: isGreaterThan, overwrite: false, completion: completion)
    }
    
    func removeLocationListener() {
        self.locationStore.removeListener()
    }
    
    func addImadokoMessageListenerOnNotReplyedAndUnRead(toId: String, isGreaterThan: Date, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?) {
        self.imadokoMessageStore.addListenerOnNotReplyedAndUnRead(toId: toId, isGreaterThan: isGreaterThan, completion: completion)
    }
    
    func addImadokoMessageListenerOnNotReplyed(toId: String, isGreaterThan: Date, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?) {
        self.imadokoMessageStore.addListenerOnNotReplyed(toId: toId, isGreaterThan: isGreaterThan, completion: completion)
    }
    
    func addKokodayoMessageListenerForAdditionalData(toId: String, isGreaterThan: Date, completion: ((Result<[KokodayoMessage], Error>) -> Void)?) {
        self.kokodayoMessageStore.addListenerForAdditionalData(toId: toId, isGreaterThan: isGreaterThan, completion: completion)
    }
    
    func removeImadokoMessageListener() {
        self.imadokoMessageStore.removeListenerOnNotReplyed()
        self.imadokoMessageStore.removeListenerOnNotReplyedAndUnRead()
    }
    
    func removeKokodayoMessageListener() {
        self.kokodayoMessageStore.removeListener()
    }
    
    func addProfileListener(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
        self.profileStore.addListener(id: id, overwrite: false, completion: completion)
    }
    
    func removeProfileListener() {
        self.profileStore.removeListener()
    }
    
    func addLocations(locations: [Location], completion: ((Error?) -> Void)?) {
        self.locationStore.batchInsert(locations, completion: completion)
    }
    
    func updateKokodayoMessageToAlreadyRead(ids: [String], completion: ((Error?) -> Void)?) {
        self.kokodayoMessageStore.batchUpdateToAlreadyRead(ids: ids, completion: completion)
    }
    
    func updateImadokoMessageToAlreadyRead(ids: [String], completion: ((Error?) -> Void)?) {
        self.imadokoMessageStore.batchUpdateToAlreadyRead(ids: ids, completion: completion)
    }
}
