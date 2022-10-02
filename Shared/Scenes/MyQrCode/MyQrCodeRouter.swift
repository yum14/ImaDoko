//
//  MyQrCodeRouter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/07.
//

import Foundation
import SwiftUI

final class MyQrCodeRouter {
    private static var lastView: MyQrCodeView?
    private static var lastUid: String?
    
    static func assembleModules(uid: String) -> AnyView {
        
        if let lastUid = self.lastUid, let lastView = self.lastView, lastUid == uid {
            return AnyView(lastView)
        }
        
        let presenter = MyQrCodePresenter(uid: uid)
        let view = MyQrCodeView(presenter: presenter)
        self.lastUid = uid
        self.lastView = view
        return AnyView(view)
    }
}
