//
//  MessageInteractor.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/06.
//

import Foundation

protocol MessageUsecase {
    func addImadokoMessagesListener(id: String, completion: ((Result<ImadokoMessages?, Error>) -> Void)?)
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?)
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?)
}

final class MessageInteractor {
    private let imadokoMessagesStore: ImadokoMessagesStore
    private let profileStore: ProfileStore
    private let avatarImageStore: AvatarImageStore
    
    init() {
        self.imadokoMessagesStore = ImadokoMessagesStore()
        self.profileStore = ProfileStore()
        self.avatarImageStore = AvatarImageStore()
    }
}

extension MessageInteractor: MessageUsecase {
    func addImadokoMessagesListener(id: String, completion: ((Result<ImadokoMessages?, Error>) -> Void)?) {
        self.imadokoMessagesStore.addListener(id: id, completion: completion)
    }
    
    func getProfiles(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?) {
        self.profileStore.getDocuments(ids: ids, completion: completion)
    }
    
    func getAvatarImages(ids: [String], completion: ((Result<[AvatarImage]?, Error>) -> Void)?) {
        self.avatarImageStore.getDocuments(ids: ids, completion: completion)
    }
}
