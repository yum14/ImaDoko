//
//  RootPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI
import MapKit

final class RootPresenter: ObservableObject {
    @Published var tabSelection: Int = 1
    
    private let interactor: RootUsecase
    private let router: RootWireframe
    
    private var loginView: AnyView?
    
    init(interactor: RootUsecase, router: RootWireframe) {
        self.interactor = interactor
        self.router = router
    }
}

extension RootPresenter {
    func onAppear(uid: String, notificationToken: String) {
        self.interactor.setNotificationToken(data: NotificationToken(id: uid, notificationToken: notificationToken)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func onOpenUrl(url: URL) {
        self.tabSelection = 2
    }
    
    func makeAboutLoginView(signInStatus: SignInStatus) -> some View {
        guard let loginView = self.loginView else {
            self.loginView = router.makeLoginView()
            return self.loginView!
        }

        if signInStatus == .newUser {
            return loginView
        } else {
            self.loginView = router.makeLoginView()
            return self.loginView!
        }
    }
    
    func makeAboutMapView(uid: String) -> some View {
        return self.router.makeMapView(uid: uid)
    }
    
    func makeAboutHomeView(uid: String) -> some View {
        return self.router.makeHomeView(uid: uid)
    }
    
    func makeAboutLaunchScreenView() -> some View {
        return self.router.makeLaunchScreenView()
    }
}
