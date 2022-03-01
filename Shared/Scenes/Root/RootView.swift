//
//  RootView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI
import StatefulTabView
import Firebase

struct RootView: View {
    @ObservedObject var presenter: RootPresenter
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var appDelegate: AppDelegate
    @State var tabSelection: Int = 2
    
    var body: some View {
        VStack {
            if !self.auth.isSignedIn {
                self.presenter.makeAboutLoginView()
            } else {
                StatefulTabView(selectedIndex: self.$tabSelection) {
                    Tab(title: NSLocalizedString("HomeViewTitle", comment: ""), systemImageName: "house") {
                        NavigationView {
                            self.presenter.makeAboutHomeView()
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationTitle(Text("HomeViewTitle"))
                                .navigationBarHidden(true)
                        }
                    }
                    
                    Tab(title: NSLocalizedString("MessageViewTitle", comment: ""), systemImageName: "message.fill") {
                        NavigationView {
                            self.presenter.makeAboutMessageView()
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationTitle(Text("MessageViewTitle"))
                                .navigationBarHidden(true)
                        }
                    }
                    Tab(title: NSLocalizedString("MapViewTitle", comment: ""), systemImageName: "mappin.and.ellipse") {
                        NavigationView {
                            self.presenter.makeAboutMapView()
                                .navigationBarTitleDisplayMode(.inline)
                            //                        .navigationTitle(Text("MapViewTitle"))
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
                    
                    self.presenter.setNotificationToken(id: firebaseLoginUser.uid, notificationToken: notificationToken)
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
                RootView(presenter: presenter, tabSelection: selection)
                    .environment(\.locale, .init(identifier: id))
                    .environmentObject(auth)
            }
        }
    }
}
