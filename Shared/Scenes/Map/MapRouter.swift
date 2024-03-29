//
//  MapRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI

protocol MapWireframe {
    func makePinDetailView(myId: String, myName: String, friend: Avatar, createdAt: Date, onDismiss: (() -> Void)?, onSend: ((Error?) -> Void)?) -> AnyView
    func makeMessageDestinationView(myId: String, myName: String, friends: [Avatar], onDismiss: (() -> Void)?, onSend: (([Error]) -> Void)?) -> AnyView
    func makeMessageView(uid: String) -> AnyView
}

final class MapRouter {
    
    private static var lastUid: String?
    private static var lastView: MapView?
    
    static func assembleModules(uid: String) -> AnyView {
        
        if let lastUid = self.lastUid, let lastView = self.lastView, lastUid == uid {
            return AnyView(lastView)
        }
        
        let interactor = MapInteractor()
        let router = MapRouter()
        let presenter = MapPresenter(interactor: interactor, router: router, uid: uid)
        let view = MapView(presenter: presenter)
        self.lastUid = uid
        self.lastView = view
        return AnyView(view)
    }
}

extension MapRouter: MapWireframe {
    
    func makePinDetailView(myId: String, myName: String, friend: Avatar, createdAt: Date, onDismiss: (() -> Void)?, onSend: ((Error?) -> Void)?) -> AnyView {
        return PinDetailRouter.assembleModules(myId: myId, myName: myName, friend: friend, createdAt: createdAt, onDismiss: onDismiss, onSend: onSend)
    }
    
    func makeMessageDestinationView(myId: String, myName: String, friends: [Avatar], onDismiss: (() -> Void)?, onSend: (([Error]) -> Void)?) -> AnyView {
        return MessageDestinationRouter.assembleModules(myId: myId, myName: myName, friends: friends, onDismiss: onDismiss, onSend: onSend)
    }
    
    func makeMessageView(uid: String) -> AnyView {
        return MessageRouter.assembleModules(uid: uid)
    }
}
