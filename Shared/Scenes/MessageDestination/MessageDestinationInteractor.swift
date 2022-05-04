//
//  MessageDestinationInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/26.
//

import Foundation

protocol MessageDestinationUsecase {
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?)
    func appendImadokoMessages(_ data: ImadokoMessage, id: String, completion: ((Error?) -> Void)?)
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
    func setImadokoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
}

final class MessageDestinationInteractor {
    private let notificationStore: NotificationStore
    private let myLocationsStore: MyLocationsStore
    private let imadokoMessagesStore: ImadokoMessagesStore
    
    init() {
        self.notificationStore = NotificationStore()
        self.myLocationsStore = MyLocationsStore()
        self.imadokoMessagesStore = ImadokoMessagesStore()
    }
}

extension MessageDestinationInteractor: MessageDestinationUsecase {
    
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?) {
        self.myLocationsStore.appendLocation(data, id: id, completion: completion)
    }
    
    func appendImadokoMessages(_ data: ImadokoMessage, id: String, completion: ((Error?) -> Void)?) {
        self.imadokoMessagesStore.appendImadokoMessage(data, id: id, completion: completion)
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
