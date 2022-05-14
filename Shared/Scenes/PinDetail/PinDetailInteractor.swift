//
//  PinDetailInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/23.
//

import Foundation

protocol PinDetailUsecase {
    func setLocation(_ data: Location, completion: ((Error?) -> Void)?)
    func setImadokoMessage(_ data: ImadokoMessage, completion: ((Error?) -> Void)?)
    func setKokodayoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
    func setImadokoNotification(fromId: String, fromName: String, toIds: [String], completion: ((Error?) -> Void)?)
}

final class PinDetailInteractor {
    private let notificationStore: NotificationStore
    private let locationStore: LocationStore
    private let imadokoMessageStore: ImadokoMessageStore
    
    init() {
        self.notificationStore = NotificationStore()
        self.locationStore = LocationStore()
        self.imadokoMessageStore = ImadokoMessageStore()
    }
}

extension PinDetailInteractor: PinDetailUsecase {
    
    func setLocation(_ data: Location, completion: ((Error?) -> Void)?) {
        self.locationStore.setData(data, completion: completion)
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
