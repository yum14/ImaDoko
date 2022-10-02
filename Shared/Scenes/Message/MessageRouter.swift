//
//  MessageRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI

protocol MessageWireframe {
}

final class MessageRouter {
    private static var lastView: MessageView?
    private static var lastUid: String?
    
    static func assembleModules(uid: String) -> AnyView {
        
        if let lastUid = self.lastUid, let lastView = self.lastView, lastUid == uid {
            return AnyView(lastView)
        }
        
        let interactor = MessageInteractor()
        let router = MessageRouter()
        let presenter = MessagePresenter(interactor: interactor, router: router, uid: uid)
        let view = MessageView(presenter: presenter)
        self.lastUid = uid
        self.lastView = view
        return AnyView(view)
    }
}

extension MessageRouter: MessageWireframe {
    
}

