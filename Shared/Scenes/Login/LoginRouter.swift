//
//  LoginRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/20.
//

import Foundation
import SwiftUI

final class LoginRouter {
    static func assembleModules() -> AnyView {
        let presenter = LoginPresenter()
        let view = LoginView(presenter: presenter)
        return AnyView(view)
    }
}
