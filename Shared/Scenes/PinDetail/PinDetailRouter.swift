//
//  PinDetailRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/23.
//

import Foundation
import SwiftUI

protocol PinDetailWireframe {
}

final class PinDetailRouter {
    private static var lastView: PinDetailView?
    private static var lastMyId: String?
    private static var lastMyName: String?
    private static var lastFriend: Avatar?
    private static var lastCreatedAt: Date?
    
    static func assembleModules(myId: String, myName: String, friend: Avatar, createdAt: Date, onDismiss: (() -> Void)?, onSend: ((Error?) -> Void)?) -> AnyView {
        
        if let lastMyId = self.lastMyId, let lastMyName = self.lastMyName, let lastFriend = self.lastFriend, let lastCreatedAt = self.lastCreatedAt, let lastView = self.lastView,
           lastMyId == myId, lastMyName == myName, lastFriend == friend, lastCreatedAt == createdAt {
            return AnyView(lastView)
        }
        
        let interactor = PinDetailInteractor()
        let router = PinDetailRouter()
        let presenter = PinDetailPresenter(interactor: interactor, router: router, myId: myId, myName: myName, friend: friend, createdAt: createdAt, onDismiss: onDismiss, onSend: onSend)
        let view = PinDetailView(presenter: presenter)
        self.lastMyId = myId
        self.lastMyName = myName
        self.lastFriend = friend
        self.lastCreatedAt = createdAt
        self.lastView = view
        return AnyView(view)
    }
}

extension PinDetailRouter: PinDetailWireframe {

}
