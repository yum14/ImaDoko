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
    func setLocation(_ data: Location, completion: ((Error?) -> Void)?)
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
    func deleteImadokoMessage(id: String, completion: ((Error?) -> Void)?)
}

final class MessageInteractor {
    private let imadokoMessageStore: ImadokoMessageStore
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    private let locationStore: LocationStore
    private let notificationStore: NotificationStore
    
    init() {
        self.imadokoMessageStore = ImadokoMessageStore()
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
        self.locationStore = LocationStore()
        self.notificationStore = NotificationStore()
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
    
    func setLocation(_ data: Location, completion: ((Error?) -> Void)?) {
        self.locationStore.getDocuments(ownerId: data.ownerId, userId: data.userId) { result in
            switch result {
            case .success(let locations):
                if let locations = locations {
            
                    // 現在地情報を削除
                    for location in locations {
                        self.locationStore.delete(id: location.id, completion: { _ in })
                    }
                    
                    // 現在地情報を追加
                    self.locationStore.setData(data, completion: completion)
                }
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?) {
        let data = NotificationMessageCreator.createKokodayoMessage(fromId: fromId, fromName: fromName, toIds: toIds)
        self.notificationStore.setData(data, completion: completion)
    }
    
    func deleteImadokoMessage(id: String, completion: ((Error?) -> Void)?) {
        self.imadokoMessageStore.delete(id: id, completion: completion)
    }
}
