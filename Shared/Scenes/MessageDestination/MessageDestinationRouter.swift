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
    static func assembleModules(myId: String, myName: String, friends: [Avatar], onDismiss: (() -> Void)?, onSend: (([Error]) -> Void)?) -> AnyView {
        let interactor = MessageDestinationInteractor()
        let router = MessageDestinationRouter()
        let presenter = MessageDestinationPresenter(interactor: interactor, router: router, myId: myId, myName: myName, friends: friends, onDismiss: onDismiss, onSend: onSend)
        let view = MessageDestinationView(presenter: presenter)
        return AnyView(view)
    }
}

extension MessageDestinationRouter: MessageDestinationWireframe {
    
}
