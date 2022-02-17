//
//  HomeRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI

protocol HomeWireframe {
    
}

final class HomeRouter {
    static func assembleModules() -> AnyView {
        let router = HomeRouter()
        let presenter = HomePresenter(router: router)
        let view = HomeView(presenter: presenter)
        return AnyView(view)
    }
}

extension HomeRouter: HomeWireframe {
    
}
