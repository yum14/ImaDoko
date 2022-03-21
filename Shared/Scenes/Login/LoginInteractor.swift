//
//  LoginInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/21.
//

import Foundation

protocol LoginUsecase {
    func createInitialMyLocations(uid: String, completion: ((Error?) -> Void)?)
    func createInitialImadokoMessages(uid: String, completion: ((Error?) -> Void)?)
}

final class LoginInteractor {
    private let myLocationsStore: MyLocationsStore
    private let imadokoMessagesStore: ImadokoMessagesStore
    
    init() {
        self.myLocationsStore = MyLocationsStore()
        self.imadokoMessagesStore = ImadokoMessagesStore()
    }
}

extension LoginInteractor: LoginUsecase {
    func createInitialMyLocations(uid: String, completion: ((Error?) -> Void)?) {
        self.myLocationsStore.setData(MyLocations(id: uid, locations: []), completion: completion)
    }
    
    func createInitialImadokoMessages(uid: String, completion: ((Error?) -> Void)?) {
        self.imadokoMessagesStore.setData(ImadokoMessages(id: uid, messages: []), completion: completion)
    }
}
