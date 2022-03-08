//
//  MyQrCodeScannerRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/08.
//

import Foundation
import SwiftUI

final class MyQrCodeScannerRouter {
    static func assembleModules(onFound: ((String) -> Void)?, onDismiss: (() -> Void)?) -> AnyView {
        let presenter = MyQrCodeScannerPresenter(onFound: onFound, onDismiss: onDismiss)
        let view = MyQrCodeScannerView(presenter: presenter)
        return AnyView(view)
    }
}
