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
    static func assembleModules() -> AnyView {
        let router = MessageRouter()
        let presenter = MessagePresenter(router: router)
        let view = MessageView(presenter: presenter)
        return AnyView(view)
    }
}

extension MessageRouter: MessageWireframe {
    
}

