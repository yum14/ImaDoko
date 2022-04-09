//
//  RootInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/28.
//

import Foundation

protocol RootUsecase {
    func setNotificationToken(data: NotificationToken, completion: ((Error?) -> Void)?)
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?)
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?)
}

final class RootInteractor {
    private let tokenStore: NotificationTokenStore
    private let avatarImageStore: AvatarImageStore
    private let myLocationsStore: MyLocationsStore
    
    init() {
        self.tokenStore = NotificationTokenStore()
        self.avatarImageStore = AvatarImageStore()
        self.myLocationsStore = MyLocationsStore()
    }
}

extension RootInteractor: RootUsecase {
    func setNotificationToken(data: NotificationToken, completion: ((Error?) -> Void)?) {
        self.tokenStore.setData(data, completion: completion)
    }
    
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?) {
        self.avatarImageStore.getDocument(id: id, completion: completion)
    }
    
    func appendMyLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?) {
        self.myLocationsStore.appendLocation(data, id: id, completion: completion)
    }
}
