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
    func deleteExpiredData(ownerId: String, deadline: Date)
}

final class RootInteractor {
    private let tokenStore: NotificationTokenStore
    private let avatarImageStore: AvatarImageStore
    private let locationStore: LocationStore
    private let imadokoMessageStore: ImadokoMessageStore
    
    init() {
        self.tokenStore = NotificationTokenStore()
        self.avatarImageStore = AvatarImageStore()
        self.locationStore = LocationStore()
        self.imadokoMessageStore = ImadokoMessageStore()
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
    
    func deleteExpiredData(ownerId: String, deadline: Date) {
        self.locationStore.getDocuments(ownerId: ownerId, isLessThan: deadline) { result in
            switch result {
            case .success(let locations):
                if let locations = locations {
                    for location in locations {
                        self.locationStore.delete(id: location.id) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        self.imadokoMessageStore.getDocuments(ownerId: ownerId, isLessThan: deadline) { result in
            switch result {
            case .success(let messages):
                if let messages = messages {
                    for message in messages {
                        self.imadokoMessageStore.delete(id: message.id) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
