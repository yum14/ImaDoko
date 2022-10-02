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
    func makeMapView(uid: String) -> AnyView
    func makeHomeView(uid: String) -> AnyView
    func makeLaunchScreenView() -> AnyView
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
    
    func makeMapView(uid: String) -> AnyView {
        return MapRouter.assembleModules(uid: uid)
    }
    
    func makeHomeView(uid: String) -> AnyView {
        return HomeRouter.assembleModules(uid: uid)
    }
    
    func makeLaunchScreenView() -> AnyView {
        return LaunchScreenRouter.assembleModules()
    }
}
