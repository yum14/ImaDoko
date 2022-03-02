//
//  RootInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/28.
//

import Foundation

protocol RootUsecase {
    func setNotificationToken(data: NotificationToken, completion: ((Error?) -> Void)?)
}

final class RootInteractor {
    private let tokenStore: NotificationTokenStore
    
    init() {
        self.tokenStore = NotificationTokenStore()
    }
}

extension RootInteractor: RootUsecase {
    func setNotificationToken(data: NotificationToken, completion: ((Error?) -> Void)?) {
        self.tokenStore.setData(data, completion: completion)
    }
}
