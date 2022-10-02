//
//  MessagePresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import MapKit

final class MessagePresenter: ObservableObject {
    @Published var unrepliedMessages: [Message] = []
    @Published var showingDeleteAlert = false
    @Published var showingSendNotificationAlert = false
    @Published var showingResultFloater = false
    
    var selectedMessage: Message?
    var profile: Profile?
    var resultFloaterText: String = ""
    
    private var messageAvatarImages: [String: Data] = [:] {
        didSet {
            let newMessages = self.unrepliedMessages.map { Message(id: $0.id, fromId: $0.fromId, fromName: $0.fromName, avatarImage: self.messageAvatarImages[$0.fromId], createdAt: $0.createdAt) }
            self.unrepliedMessages = newMessages
        }
    }
    
    private var messagesWithoutAvatarImage: [Message] = [] {
        didSet {
            let newMessages = self.messagesWithoutAvatarImage.map { Message(id: $0.id, fromId: $0.fromId, fromName: $0.fromName, avatarImage: self.messageAvatarImages[$0.id], createdAt: $0.createdAt) }
            self.unrepliedMessages = newMessages
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
        
        // Listner追加
        // onAppearではバックグラウンド⇨フォアグラウンドのときに対応できないためinitで実施する
        self.addListener()
    }
    
    deinit {
        self.removeListener()
    }
}

extension MessagePresenter {
    
    private func addListener() {
        
        // profile取得
        self.interactor.getProfile(id: self.uid) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // イマドコメッセージのリスナー作成
        self.interactor.addImadokoMessageListenerOnNotReplyed(toId: self.uid, isGreaterThan: Date().addingTimeInterval(-60*60*24)) { result in
            switch result {
            case .success(let imadokoMessages):
                
                self.messagesWithoutAvatarImage = []
                
                if let imadokoMessages = imadokoMessages {
                    
                    let userIds = imadokoMessages.map { $0.fromId }
                    
                    // イマドコメッセージ送信元のユーザ名を取得（キャッシュあり）
                    self.getProfiles(ids: userIds) { profiles in
                        if let profiles = profiles {
                            let newMessages = imadokoMessages
                                .map({ message in
                                    Message(id: message.id,
                                            fromId: message.fromId,
                                            fromName: profiles.first{ $0.id == message.fromId }?.name ?? "",
                                            avatarImage: nil,
                                            createdAt: message.createdAt.dateValue())
                                })
                            
                            self.messagesWithoutAvatarImage = newMessages
                        }
                    }
                    
                    // イマドコメッセージ送信元のアバターイメージを取得（キャッシュあり）
                    self.getAvatarImages(ids: userIds) { avatarImages in
                        if let avatarImages = avatarImages {
                            var newImages: [String:Data] = [:]
                            for image in avatarImages {
                                newImages[image.id] = image.data
                            }
                            
                            self.messageAvatarImages = newImages
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func getProfiles(ids: [String], completion: (([Profile]?) -> Void)?) {
        self.interactor.getProfiles(ids: ids) { result in
            switch result {
            case .success(let profiles):
                completion?(profiles)
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil)
            }
        }
    }
    
    private func getAvatarImages(ids: [String], completion: (([AvatarImage]?) -> Void)?) {
        self.interactor.getAvatarImages(ids: ids) { result in
            switch result {
            case .success(let avatarImages):
                completion?(avatarImages)
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil)
            }
        }
    }
    
    private func removeListener() {
        self.interactor.removeImadokoMessageListener()
    }
    
    func onSendButtonTap(message: Message) {
        self.selectedMessage = message
        self.showingSendNotificationAlert = true
    }
    
    func onTrashButtonTap(message: Message) {
        self.selectedMessage = message
        self.showingDeleteAlert = true
    }
    
    func onSendLocationConfirm(myLocation: CLLocationCoordinate2D) {
        guard let selectedMessage = self.selectedMessage, let profile = self.profile else {
            return
        }
        
        // ココダヨメッセージを追加
        let message = KokodayoMessage(fromId: profile.id, toId: selectedMessage.fromId, latitude: myLocation.latitude, longitude: myLocation.longitude)
        self.interactor.setKokodayoMessage(message) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        // プッシュ通知
        self.interactor.setKokodayoNotification(fromId: profile.id, fromName: profile.name, toIds: [selectedMessage.fromId]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        // イマドコメッセージを返信済にする
        self.interactor.batchUpdateToReplyed(ids: [selectedMessage.id]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func onDeleteMessageConfirm() {
        guard let selectedMessage = self.selectedMessage else {
            return
        }
        
        // イマドコメッセージを返信済にする
        self.interactor.batchUpdateToReplyed(ids: [selectedMessage.id]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func onDisappear() {
        self.showingResultFloater = false
    }
}
