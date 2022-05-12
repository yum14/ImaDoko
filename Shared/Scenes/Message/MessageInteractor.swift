//
//  MessageInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/06.
//

import Foundation

protocol MessageUsecase {
    func addImadokoMessagesListener(id: String, completion: ((Result<ImadokoMessages?, Error>) -> Void)?)
    func removeImadokoMessagesListener()
    func getProfile(id: String, completion: ((Result<Profile?, Error>) -> Void)?)
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?)
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?)
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?)
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
}

final class MessageInteractor {
    private let imadokoMessagesStore: ImadokoMessagesStore
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    private let myLocationsStore: MyLocationsStore
    private let notificationStore: NotificationStore
    
    init() {
        self.imadokoMessagesStore = ImadokoMessagesStore()
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
        self.myLocationsStore = MyLocationsStore()
        self.notificationStore = NotificationStore()
    }
}

extension MessageInteractor: MessageUsecase {
    func addImadokoMessagesListener(id: String, completion: ((Result<ImadokoMessages?, Error>) -> Void)?) {
        self.imadokoMessagesStore.addListener(id: id, completion: completion)
    }
    
    func removeImadokoMessagesListener() {
        self.imadokoMessagesStore.removeListener()
    }
    
    func getProfile(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
        self.profileStore.getDocument(id: id, completion: completion)
    }
    
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?) {
        self.profileStore.getDocuments(ids: ids, completion: completion)
    }
    
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?) {
        self.avatarImageStore.getDocuments(ids: ids, completion: completion)
    }
    
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?) {
        self.myLocationsStore.appendLocation(data, id: id, completion: completion)
    }
    
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?) {
        let data = NotificationMessageCreator.createKokodayoMessage(fromId: fromId, fromName: fromName, toIds: toIds)
        self.notificationStore.setData(data, completion: completion)
    }
}
