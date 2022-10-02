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
    func makeMyQrCodeScannerView(onFound: ((String) -> Void)?) -> AnyView
}

final class HomeRouter {
    private static var lastView: HomeView?
    private static var lastUid: String?
    
    static func assembleModules(uid: String) -> AnyView {
        
        if let lastUid = self.lastUid, let lastView = self.lastView, lastUid == uid {
            return AnyView(lastView)
        }
        
        let router = HomeRouter()
        let interactor = HomeInteractor()
        let presenter = HomePresenter(interactor: interactor, router: router, uid: uid)
        let view = HomeView(presenter: presenter)
        self.lastUid = uid
        self.lastView = view
        return AnyView(view)
    }
}

extension HomeRouter: HomeWireframe {
    func makeMyQrCodeView(uid: String) -> AnyView {
        return MyQrCodeRouter.assembleModules(uid: uid)
    }
    
    func makeMyQrCodeScannerView(onFound: ((String) -> Void)?) -> AnyView {
        return MyQrCodeScannerRouter.assembleModules(onFound: onFound)
    }
}
