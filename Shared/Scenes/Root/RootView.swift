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
            if !self.auth.isSignedIn {
                self.presenter.makeAboutLoginView()
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
                            
                            Tab(title: NSLocalizedString("MessageViewTitle", comment: ""), systemImageName: "message.fill") {
                                NavigationView {
                                    self.presenter.makeAboutMessageView(uid: loginUser.uid)
                                        .navigationBarTitleDisplayMode(.inline)
                                        .navigationTitle(Text("MessageViewTitle"))
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
                        
                        .popup(isPresented: self.$presenter.showingNotificationPopup,
                               type: .default,
                               position: .bottom,
                               animation: .default,
                               dragToDismiss: true,
                               closeOnTap: false,
                               closeOnTapOutside: false,
                               backgroundColor: Color.black.opacity(0.2),
                               dismissCallback: {},
                               view: {
                            ImadokoNotificationView(userName: self.presenter.receivedNotification?.name,
                                                    avatarImage: self.presenter.receivedNotification?.avatarImage,
                                                    onReply: {
                                self.presenter.onImadokoNotificationReply(id: self.auth.profile!.id, location: self.appDelegate.region.center)},
                                                    onDismiss: self.presenter.onImadokoNotificationDismiss)
                            EmptyView()
                        })
                        
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
