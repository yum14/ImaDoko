//
//  RootRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI

protocol RootWireframe {
    func makeLoginView() -> AnyView
    func makeMapView() -> AnyView
    func makeHomeView() -> AnyView
    func makeMessageView() -> AnyView
}

final class RootRouter {
    static func assembleModules() -> AnyView {
        let interactor = RootInteractor()
        let router = RootRouter()
        let presenter = RootPresenter(interactor: interactor, router: router)
        let view = RootView(presenter: presenter)
        return AnyView(view)
    }
}

extension RootRouter: RootWireframe {
    func makeLoginView() -> AnyView {
        return LoginRouter.assembleModules()
    }
    
    func makeMapView() -> AnyView {
        return MapRouter.assembleModules()
    }
    
    func makeHomeView() -> AnyView {
        return HomeRouter.assembleModules()
    }
    
    func makeMessageView() -> AnyView {
        return MessageRouter.assembleModules()
    }
}
