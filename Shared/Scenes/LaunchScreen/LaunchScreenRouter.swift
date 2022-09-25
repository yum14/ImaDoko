//
//  LaunchScreenRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/09/24.
//

import Foundation
import SwiftUI

final class LaunchScreenRouter {
    static func assembleModules() -> AnyView {
        let view = LaunchScreenView()
        return AnyView(view)
    }
}

