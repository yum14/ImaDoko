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
    static func assembleModules(myId: String, myName: String, friend: Avatar, createdAt: Date, onDismiss: (() -> Void)?) -> AnyView {
        let interactor = PinDetailInteractor()
        let router = PinDetailRouter()
        let presenter = PinDetailPresenter(interactor: interactor, router: router, myId: myId, myName: myName, friend: friend, createdAt: createdAt, onDismiss: onDismiss)
        let view = PinDetailView(presenter: presenter)
        return AnyView(view)
    }
}

extension PinDetailRouter: PinDetailWireframe {

}
