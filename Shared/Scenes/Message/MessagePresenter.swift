//
//  MessagePresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation

final class MessagePresenter: ObservableObject {
    @Published var messageTypeSelection = 0
    @Published var unreadMessages: [Message] = []
    
    private var messageAvatarImages: [String: Data] = [:] {
        didSet {
            let newMessages = self.unreadMessages.map { Message(id: $0.id, from: $0.from, avatarImage: self.messageAvatarImages[$0.id], createdAt: $0.createdAt) }
            self.unreadMessages = newMessages
        }
    }
    
    private var messagesWithoutAvatarImage: [Message] = [] {
        didSet {
            let newMessages = self.messagesWithoutAvatarImage.map { Message(id: $0.id, from: $0.from, avatarImage: self.messageAvatarImages[$0.id], createdAt: $0.createdAt) }
            self.unreadMessages = newMessages
        }
    }
    
    private let interactor: MessageUsecase
    private let router: MessageWireframe
    private let uid: String
    
    init(interactor: MessageUsecase,
         router: MessageWireframe,
         uid: String) {
        self.interactor = interactor
        self.router = router
        self.uid = uid
    }
}

extension MessagePresenter {
    
    func onAppear() {
        
        // イマドコメッセージのリスナー作成
        self.interactor.addImadokoMessagesListener(id: self.uid) { result in
            switch result {
            case .success(let imadokoMessages):
                if let imadokoMessages = imadokoMessages {
                    
                    let userIds = imadokoMessages.messages.map { $0.id }
                    
                    // イマドコメッセージ送信元のユーザ名を取得
                    self.interactor.getProfiles(ids: userIds) { result in
                        switch result {
                        case .success(let profiles):
                            if let profiles = profiles {
                                // 対象は1日前まで
                                let newMessages = imadokoMessages.messages
                                    .filter({ !$0.replyed && $0.createdAt.dateValue().addingTimeInterval(60*60*24*10) >= Date.now })
                                    .map({ message in
                                        Message(id: message.id, from: profiles.first{ $0.id == message.id }?.name ?? "",
                                                avatarImage: nil,
                                                createdAt: message.createdAt.dateValue())
                                    })
                                
                                self.messagesWithoutAvatarImage = newMessages
                                
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    
                    // イマドコメッセージ送信元のアバターイメージを取得
                    self.interactor.getAvatarImages(ids: userIds) { result in
                        switch result {
                        case .success(let avatarImages):
                            if let avatarImages = avatarImages {
                                
                                var newImages: [String:Data] = [:]
                                for image in avatarImages {
                                    newImages[image.id] = image.data
                                }
                                
                                self.messageAvatarImages = newImages
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
