//
//  HomeView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                AvatorCircleImage(image: nil, radius: 120)
                
                TextField("AccountName", text: self.$presenter.accountName)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))
            
            Form {
                Section {
                    List {
                        ForEach(self.presenter.friends, id: \.self) { friend in
                            FriendListItem(name: friend.name, avatorImage: friend.avatorImage)
                        }
                    }
                } header: {
                    Text("FriendListHeader")
                }

                Section {
                    Button {

                    } label: {
                        HStack {
                            Spacer()
                            Text("AddFriendButton")
                            Spacer()
                        }
                    }

                    Button {

                    } label: {
                        HStack {
                            Spacer()
                            Text("ShowMyQRCodeButton")
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let router = HomeRouter()
        let presenter = HomePresenter(router: router)
        presenter.accountName = "マイアカウント"
        presenter.friends = [User(name: "友だち１"),
                             User(name: "友だち２")]
        
        return ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                HomeView(presenter: presenter)
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
            }
        }
    }
}
