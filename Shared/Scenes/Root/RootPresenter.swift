//
//  RootPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI

final class RootPresenter: ObservableObject {
    
    private let interactor: RootUsecase
    private let router: RootWireframe
    
    init(interactor: RootUsecase, router: RootWireframe) {
        self.interactor = interactor
        self.router = router
    }
}

extension RootPresenter {
    func setNotificationToken(id: String, notificationToken: String) {
        self.interactor.setNotificationToken(data: NotificationToken(id: id, notificationToken: notificationToken)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeAboutLoginView() -> some View {
        return router.makeLoginView()
    }
    
    func makeAboutMapView(uid: String) -> some View {
        return router.makeMapView(uid: uid)
    }
    
    func makeAboutHomeView(uid: String) -> some View {
        return router.makeHomeView(uid: uid)
    }
    
    func makeAboutMessageView(uid: String) -> some View {
        return router.makeMessageView(uid: uid)
    }
}
