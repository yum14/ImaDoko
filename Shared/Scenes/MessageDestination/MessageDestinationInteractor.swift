//
//  MessageDestinationInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/26.
//

import Foundation

protocol MessageDestinationUsecase {
    func setLocation(_ data: Location, completion: ((Error?) -> Void)?)
    func setImadokoMessage(_ data: ImadokoMessage, completion: ((Error?) -> Void)?)
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
    func setImadokoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
}

final class MessageDestinationInteractor {
    private let notificationStore: NotificationStore
    private let locationStore: LocationStore
    private let imadokoMessageStore: ImadokoMessageStore
    
    init() {
        self.notificationStore = NotificationStore()
        self.locationStore = LocationStore()
        self.imadokoMessageStore = ImadokoMessageStore()
    }
}

extension MessageDestinationInteractor: MessageDestinationUsecase {
    
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
    
    func setImadokoMessage(_ data: ImadokoMessage, completion: ((Error?) -> Void)?) {
        self.imadokoMessageStore.setData(data, completion: completion)
    }
    
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?) {
        let data = NotificationMessageCreator.createKokodayoMessage(fromId: fromId, fromName: fromName, toIds: toIds)
        self.notificationStore.setData(data, completion: completion)
    }
    
    func setImadokoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?) {
        let data = NotificationMessageCreator.createImadokoMessage(fromId: fromId, fromName: fromName, toIds: toIds)
        self.notificationStore.setData(data, completion: completion)
    }
}
