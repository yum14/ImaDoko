//
//  LoginRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/20.
//

import Foundation
import SwiftUI

protocol LoginWireframe {
    
}

final class LoginRouter {
    static func assembleModules() -> AnyView {
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(interactor: interactor, router: router)
        let view = LoginView(presenter: presenter)
        return AnyView(view)
    }
}

extension LoginRouter: LoginWireframe {
    
}
