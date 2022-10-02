//
//  MessageDestinationRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/26.
//

import Foundation
import SwiftUI

protocol MessageDestinationWireframe {
}

final class MessageDestinationRouter {
    private static var lastView: MessageDestinationView?
    private static var lastMyId: String?
    private static var lastName: String?
    private static var lastFriends: [Avatar]?
    
    static func assembleModules(myId: String, myName: String, friends: [Avatar], onDismiss: (() -> Void)?, onSend: (([Error]) -> Void)?) -> AnyView {
       
        if let lastMyId = self.lastMyId, let lastName = self.lastName, let lastFriends = self.lastFriends, let lastView = self.lastView,
           lastMyId == myId, lastName == myName, lastFriends == friends
        {
            return AnyView(lastView)
        }
        
        let interactor = MessageDestinationInteractor()
        let router = MessageDestinationRouter()
        let presenter = MessageDestinationPresenter(interactor: interactor, router: router, myId: myId, myName: myName, friends: friends, onDismiss: onDismiss, onSend: onSend)
        let view = MessageDestinationView(presenter: presenter)
        self.lastMyId = myId
        self.lastName = myName
        self.lastFriends = friends
        self.lastView = view
        return AnyView(view)
    }
}

extension MessageDestinationRouter: MessageDestinationWireframe {
    
}
