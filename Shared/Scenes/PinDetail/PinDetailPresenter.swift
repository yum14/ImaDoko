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
    
    private let interactor: PinDetailUsecase
    private let router: PinDetailWireframe
    
    init(interactor: PinDetailUsecase,
         router: PinDetailWireframe,
         myId: String,
         myName: String,
         friend: Avatar,
         createdAt: Date,
         onDismiss: (() -> Void)?) {
        self.interactor = interactor
        self.router = router
        self.myId = myId
        self.myName = myName
        self.friend = friend
        self.createdAt = createdAt
        self.onDismiss = onDismiss
    }
}

extension PinDetailPresenter {
    func onKokodayoButtonTap(myLocation: CLLocationCoordinate2D) {

        let location = Location(id: self.myId, latitude: myLocation.latitude, longitude: myLocation.longitude)

        // 現在地情報を追加
        self.interactor.appendMyLocation(location, id: self.friend.id) { error in
            if let error = error {
                print(error.localizedDescription)
            }
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

        let message = ImadokoMessage(id: self.myId)

        // イマドコメッセージを追加
        self.interactor.appendImadokoMessages(message, id: self.friend.id) { error in
            if let error = error {
                print(error.localizedDescription)
            }
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
