//
//  MessageInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/06.
//

import Foundation

protocol MessageUsecase {
    func addImadokoMessageListenerForAdditionalData(toId: String, isGreaterThan: Date, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?)
    func removeImadokoMessageListener()
    func getProfile(id: String, completion: ((Result<Profile?, Error>) -> Void)?)
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?)
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?)
    func setKokodayoMessage(_ data: KokodayoMessage, completion: ((Error?) -> Void)?)
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
    func deleteImadokoMessage(id: String, completion: ((Error?) -> Void)?)
}

final class MessageInteractor {
    private let imadokoMessageStore: ImadokoMessageStore
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    private let notificationStore: NotificationStore
    private let kokodayoMessageStore: KokodayoMessageStore
    
    init() {
        self.imadokoMessageStore = ImadokoMessageStore()
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
        self.notificationStore = NotificationStore()
        self.kokodayoMessageStore = KokodayoMessageStore()
    }
}

extension MessageInteractor: MessageUsecase {
    func addImadokoMessageListenerForAdditionalData(toId: String, isGreaterThan: Date, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?) {
        self.imadokoMessageStore.addListenerForAdditionalData(toId: toId, isGreaterThan: isGreaterThan, completion: completion)
    }
    
    func removeImadokoMessageListener() {
        self.imadokoMessageStore.removeListener()
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
    
    func setKokodayoMessage(_ data: KokodayoMessage, completion: ((Error?) -> Void)?) {
        self.kokodayoMessageStore.setData(data, completion: completion)
    }
    
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?) {
        let data = NotificationMessageCreator.createKokodayoMessage(fromId: fromId, fromName: fromName, toIds: toIds)
        self.notificationStore.setData(data, completion: completion)
    }
    
    func deleteImadokoMessage(id: String, completion: ((Error?) -> Void)?) {
        self.imadokoMessageStore.delete(id: id, completion: completion)
    }
}
