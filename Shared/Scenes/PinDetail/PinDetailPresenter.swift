//
//  PinDetailPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/23.
//

import Foundation
import MapKit

final class PinDetailPresenter: ObservableObject {
 
    private var myId: String
    private var myName: String
    @Published var friend: Avatar
    @Published var createdAt: Date
    
    var onDismiss: (() -> Void)?
    var onSend: ((Error?) -> Void)?
    
    private let interactor: PinDetailUsecase
    private let router: PinDetailWireframe
    
    init(interactor: PinDetailUsecase,
         router: PinDetailWireframe,
         myId: String,
         myName: String,
         friend: Avatar,
         createdAt: Date,
         onDismiss: (() -> Void)?,
         onSend: ((Error?) -> Void)?) {
        self.interactor = interactor
        self.router = router
        self.myId = myId
        self.myName = myName
        self.friend = friend
        self.createdAt = createdAt
        self.onDismiss = onDismiss
        self.onSend = onSend
    }
}

extension PinDetailPresenter {
    func onKokodayoButtonTap(myLocation: CLLocationCoordinate2D) {

        let location = Location(userId: self.myId, ownerId: self.friend.id, latitude: myLocation.latitude, longitude: myLocation.longitude)
        
        // 現在地情報を追加
        self.interactor.setLocation(location) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.onSend?(error)
        }

        // プッシュ通知
        self.interactor.setKokodayoNotification(fromId: self.myId, fromName: self.myName, toIds: [self.friend.id]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        self.onDismiss?()
    }
    
    func onImadokoButtonTap() {

        let message = ImadokoMessage(userId: self.myId, ownerId: self.friend.id)
        
        // イマドコメッセージを追加
        self.interactor.setImadokoMessage(message) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.onSend?(error)
        }

        // プッシュ通知
        self.interactor.setImadokoNotification(fromId: self.myId, fromName: self.myName, toIds: [self.friend.id]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        self.onDismiss?()
    }
}
