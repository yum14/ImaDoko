//
//  MapRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI

protocol MapWireframe {
}

final class MapRouter {
    static func assembleModules(uid: String) -> AnyView {
        let router = MapRouter()
        let presenter = MapPresenter(router: router, uid: uid)
        let view = MapView(presenter: presenter)
        return AnyView(view)
    }
}

extension MapRouter: MapWireframe {
    
}
