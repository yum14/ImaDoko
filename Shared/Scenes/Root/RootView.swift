//
//  RootView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI
import StatefulTabView

struct RootView: View {
    @ObservedObject var presenter: RootPresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    @State var tabSelection: Int = 2
    
    var body: some View {
        
        if !self.authStateObserver.isSignedIn {
            LoginView()
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
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let router = RootRouter()
        let presenter = RootPresenter(router: router)
        
        ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach(0...2, id: \.self) { selection in
                RootView(presenter: presenter, tabSelection: selection)
                    .environment(\.locale, .init(identifier: id))
            }
        }
    }
}
