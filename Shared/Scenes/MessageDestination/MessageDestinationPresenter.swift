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
    let onSend: (([Error]) -> Void)?
    
    var sendStatus: [String:Error?] = [:] {
        didSet {
            if self.selectedIds.count != self.sendStatus.count {
                return
            }

            let errors = self.sendStatus.compactMap({(key, error) in error})
            
            self.onSend?(errors)
        }
    }
    
    private let interactor: MessageDestinationUsecase
    private let router: MessageDestinationWireframe
    
    init(interactor: MessageDestinationUsecase,
         router: MessageDestinationWireframe,
         myId: String,
         myName: String,
         friends: [Avatar],
         onDismiss: (() -> Void)?,
         onSend: (([Error]) -> Void)?) {
        self.interactor = interactor
        self.router = router
        self.myId = myId
        self.myName = myName
        self.friends = friends
        self.onDismiss = onDismiss
        self.onSend = onSend
    }
}

extension MessageDestinationPresenter {
    func onKokodayoButtonTap(myLocation: CLLocationCoordinate2D) {
        if self.selectedIds.count == 0 {
            return
        }
        
        // ココダヨメッセージを追加
        for friendId in self.selectedIds {
            let message = KokodayoMessage(fromId: self.myId, toId: friendId, latitude: myLocation.latitude, longitude: myLocation.longitude)
            self.interactor.setKokodayoMessage(message) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                self.sendStatus[friendId] = error
            }
        }

        // プッシュ通知
        self.interactor.setKokodayoNotification(fromId: self.myId, fromName: self.myName, toIds: self.selectedIds) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        self.sendStatus = [:]
        self.onDismiss?()
    }
    
    func onImadokoButtonTap() {
        if self.selectedIds.count == 0 {
            return
        }

        // イマドコメッセージを追加
        for friendId in self.selectedIds {
            let message = ImadokoMessage(fromId: self.myId, toId: friendId)
            self.interactor.setImadokoMessage(message) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                self.sendStatus[friendId] = error
            }
        }

        // プッシュ通知
        self.interactor.setImadokoNotification(fromId: self.myId, fromName: self.myName, toIds: self.selectedIds) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        self.sendStatus = [:]
        self.onDismiss?()
    }
}
