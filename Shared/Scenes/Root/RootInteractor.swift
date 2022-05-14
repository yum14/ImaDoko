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
    func setLocation(_ data: Location, completion: ((Error?) -> Void)?)
}

final class RootInteractor {
    private let tokenStore: NotificationTokenStore
    private let avatarImageStore: AvatarImageStore
    private let locationStore: LocationStore
    
    init() {
        self.tokenStore = NotificationTokenStore()
        self.avatarImageStore = AvatarImageStore()
        self.locationStore = LocationStore()
    }
}

extension RootInteractor: RootUsecase {
    func setNotificationToken(data: NotificationToken, completion: ((Error?) -> Void)?) {
        self.tokenStore.setData(data, completion: completion)
    }
    
    func getAvatarImage(id: String, completion: ((Result<AvatarImage?, Error>) -> Void)?) {
        self.avatarImageStore.getDocument(id: id, completion: completion)
    }
    
    func setLocation(_ data: Location, completion: ((Error?) -> Void)?) {
        self.locationStore.setData(data, completion: completion)
    }
}
