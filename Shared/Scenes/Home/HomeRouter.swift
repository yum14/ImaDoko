//
//  HomeRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI

protocol HomeWireframe {
    func makeMyQrCodeView(uid: String) -> AnyView
}

final class HomeRouter {
    static func assembleModules(uid: String) -> AnyView {
        let router = HomeRouter()
        let interactor = HomeInteractor()
        let presenter = HomePresenter(interactor: interactor, router: router, uid: uid)
        let view = HomeView(presenter: presenter)
        return AnyView(view)
    }
}

extension HomeRouter: HomeWireframe {
    func makeMyQrCodeView(uid: String) -> AnyView {
        return MyQrCodeRouter.assembleModules(uid: uid)
    }
}
