//
//  MessageDestinationPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/26.
//

import Foundation
import SwiftUI
import MapKit

final class MessageDestinationPresenter: ObservableObject {
    
    @Published var friends: [Avatar] = []
    @Published var selectedIds: [String] = []
    
    let myId: String
    let myName: String
    let onDismiss: (() -> Void)?
    
    private let interactor: MessageDestinationUsecase
    private let router: MessageDestinationWireframe
    
    init(interactor: MessageDestinationUsecase,
         router: MessageDestinationWireframe,
         myId: String,
         myName: String,
         friends: [Avatar],
         onDismiss: (() -> Void)?) {
        self.interactor = interactor
        self.router = router
        self.myId = myId
        self.myName = myName
        self.friends = friends
        self.onDismiss = onDismiss
    }
}

extension MessageDestinationPresenter {
    func onKokodayoButtonTap(myLocation: CLLocationCoordinate2D) {
        if self.selectedIds.count == 0 {
            return
        }
        
        // 現在地情報を追加
        for friendId in self.selectedIds {
            let location = Location(userId: self.myId, ownerId: friendId, latitude: myLocation.latitude, longitude: myLocation.longitude)
            self.interactor.setLocation(location) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }

        // プッシュ通知
        self.interactor.setKokodayoNotification(fromId: self.myId, fromName: self.myName, toIds: self.selectedIds) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        self.onDismiss?()
    }
    
    func onImadokoButtonTap() {
        if self.selectedIds.count == 0 {
            return
        }

        // イマドコメッセージを追加
        for friendId in self.selectedIds {
            let message = ImadokoMessage(userId: self.myId, ownerId: friendId)
            self.interactor.setImadokoMessage(message) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }

        // プッシュ通知
        self.interactor.setImadokoNotification(fromId: self.myId, fromName: self.myName, toIds: self.selectedIds) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        self.onDismiss?()
    }
}
