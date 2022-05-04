//
//  MapRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI

protocol MapWireframe {
    func makePinDetailView(myId: String, myName: String, friend: Avatar, createdAt: Date, onDismiss: (() -> Void)?) -> AnyView
    func makeMessageDestinationView(myId: String, myName: String, friends: [Avatar], onDismiss: (() -> Void)?) -> AnyView
}

final class MapRouter {
    static func assembleModules(uid: String) -> AnyView {
        let interactor = MapInteractor()
        let router = MapRouter()
        let presenter = MapPresenter(interactor: interactor, router: router, uid: uid)
        let view = MapView(presenter: presenter)
        return AnyView(view)
    }
}

extension MapRouter: MapWireframe {
    func makePinDetailView(myId: String, myName: String, friend: Avatar, createdAt: Date, onDismiss: (() -> Void)?) -> AnyView {
        return PinDetailRouter.assembleModules(myId: myId, myName: myName, friend: friend, createdAt: createdAt, onDismiss: onDismiss)
    }
    
    func makeMessageDestinationView(myId: String, myName: String, friends: [Avatar], onDismiss: (() -> Void)?) -> AnyView {
        return MessageDestinationRouter.assembleModules(myId: myId, myName: myName, friends: friends, onDismiss: onDismiss)
    }
}
