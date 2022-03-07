//
//  HomeView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                AvatorCircleImage(image: nil, radius: 120)
                
                TextField("AccountName", text: self.$presenter.accountName)
                    .multilineTextAlignment(.center)
                    .onSubmit {
                        self.presenter.onNameTextSubmit()
                    }
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
                        self.presenter.onMyQrCodeButtonTap()
                    } label: {
                        HStack {
                            Spacer()
                            Text("ShowMyQRCodeButton")
                            Spacer()
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        self.presenter.onSignOutButtonTapped(auth: self.auth)
                    } label: {
                        HStack {
                            Spacer()
                            Text("SignOutButton")
                            Spacer()
                        }
                    }

                }
            }
        }
        .sheet(isPresented: self.$presenter.showQrCodeSheet) {
            NavigationView {
                self.presenter.makeAboutMyQrCodeView()
            }
        }
        .onAppear {
            self.presenter.addProfileListener()
        }
        .onDisappear {
            self.presenter.removeProfileListener()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let auth = Authentication()
    
    static var previews: some View {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router, uid: "")
        presenter.accountName = "マイアカウント"
        presenter.friends = [Profile(name: "友だち１"),
                             Profile(name: "友だち２")]
        
        return ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                HomeView(presenter: presenter)
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
                    .environmentObject(auth)
            }
        }
    }
}
