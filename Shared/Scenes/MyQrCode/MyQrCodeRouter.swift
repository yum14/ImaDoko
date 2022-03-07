//
//  MyQrCodeRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/07.
//

import Foundation
import SwiftUI

final class MyQrCodeRouter {
    static func assembleModules(uid: String) -> AnyView {
        let presenter = MyQrCodePresenter(uid: uid)
        let view = MyQrCodeView(presenter: presenter)
        return AnyView(view)
    }
}
