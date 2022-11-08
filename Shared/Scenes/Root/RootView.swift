//
//  RootView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI
import StatefulTabView
import Firebase
import PopupView

struct RootView: View {
    @ObservedObject var presenter: RootPresenter
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var appDelegate: AppDelegate
    
    var body: some View {
        VStack {
            if self.auth.signInStatus == .notYet {
                self.presenter.makeAboutLaunchScreenView()
            } else if [SignInStatus.failed, SignInStatus.newUser].contains { $0 == self.auth.signInStatus } {
                self.presenter.makeAboutLoginView(signInStatus: self.auth.signInStatus)
            } else {
                if let loginUser = self.auth.firebaseLoginUser {
                    ZStack {

                        StatefulTabView(selectedIndex: self.$presenter.tabSelection) {
                            Tab(title: NSLocalizedString("HomeViewTitle", comment: ""), systemImageName: "house") {
                                NavigationView {
                                    self.presenter.makeAboutHomeView(uid: loginUser.uid)
                                        .navigationBarTitleDisplayMode(.inline)
                                        .navigationTitle(Text("HomeViewTitle"))
                                        .navigationBarHidden(true)
                                }
                            }

                            Tab(title: NSLocalizedString("MapViewTitle", comment: ""), systemImageName: "mappin.and.ellipse") {
                                NavigationView {
                                    self.presenter.makeAboutMapView(uid: loginUser.uid)
                                        .navigationBarTitleDisplayMode(.inline)
                                        .navigationBarHidden(true)
                                }

                            }
                        }
                        .barTintColor(UIColor(Color("MainColor")))
                        .unselectedItemTintColor(UIColor(Color.secondary))
                        .barBackgroundColor(UIColor.systemBackground)
                        .barAppearanceConfiguration(.transparent)
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear {
                            guard let firebaseLoginUser = self.auth.firebaseLoginUser, let notificationToken = self.appDelegate.notificationToken else {
                                return
                            }
                            self.presenter.onAppear(uid: firebaseLoginUser.uid, notificationToken: notificationToken)
                        }
                        .onOpenURL(perform: self.presenter.onOpenUrl)
                    }
                }
            }
        }
        .onAppear {
            self.auth.addListener()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static let auth = Authentication()
    
    static var previews: some View {
        let interactor = RootInteractor()
        let router = RootRouter()
        let presenter = RootPresenter(interactor: interactor, router: router)
        
        ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach(0...2, id: \.self) { selection in
                RootView(presenter: presenter)
                    .environment(\.locale, .init(identifier: id))
                    .environmentObject(auth)
            }
        }
    }
}
