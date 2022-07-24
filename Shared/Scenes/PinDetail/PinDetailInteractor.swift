//
//  PinDetailInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/23.
//

import Foundation

protocol PinDetailUsecase {
    func setImadokoMessage(_ data: ImadokoMessage, completion: ((Error?) -> Void)?)
    func setKokodayoMessage(_ data: KokodayoMessage, completion: ((Error?) -> Void)?)
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
    func setImadokoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
}

final class PinDetailInteractor {
    private let notificationStore: NotificationStore
    private let imadokoMessageStore: ImadokoMessageStore
    private let kokodayoMessageStore: KokodayoMessageStore
    
    init() {
        self.notificationStore = NotificationStore()
        self.imadokoMessageStore = ImadokoMessageStore()
        self.kokodayoMessageStore = KokodayoMessageStore()
    }
}

extension PinDetailInteractor: PinDetailUsecase {
    func setImadokoMessage(_ data: ImadokoMessage, completion: ((Error?) -> Void)?) {
        self.imadokoMessageStore.setData(data, completion: completion)
    }
    
    func setKokodayoMessage(_ data: KokodayoMessage, completion: ((Error?) -> Void)?) {
        self.kokodayoMessageStore.setData(data, completion: completion)
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
