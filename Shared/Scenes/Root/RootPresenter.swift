//
//  RootPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI

final class RootPresenter: ObservableObject {
    
    private let router: RootWireframe
    
    init(router: RootWireframe) {
        self.router = router
    }
}

extension RootPresenter {
    func makeAboutMapView() -> some View {
        return router.makeMapView()
    }
    
    func makeAboutHomeView() -> some View {
        return router.makeHomeView()
    }
    
    func makeAboutMessageView() -> some View {
        return router.makeMessageView()
    }
}
