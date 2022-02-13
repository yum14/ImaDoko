//
//  RootView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var presenter: RootPresenter
    @State var tabSelection: Int = 2
    
    var body: some View {
        TabView(selection: self.$tabSelection) {
            self.presenter.makeAboutHomeView()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            self.presenter.makeAboutMessageView()
                .tabItem {
                    Image(systemName: "message.fill")
                }
                .tag(1)
            
            self.presenter.makeAboutMapView()
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                }
                .tag(2)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let router = RootRouter()
        let presenter = RootPresenter(router: router)
        
        ForEach(0...2, id: \.self) { selection in
            RootView(presenter: presenter, tabSelection: selection)
                .environment(\.locale, .init(identifier: "ja_JP"))
        }
    }
}
