//
//  HomeView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI
import Combine
import PopupView

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
    @EnvironmentObject var appDelegate: AppDelegate
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                AvatarImagePicker(selectedImage: self.$presenter.avatarImage, radius: 120)
                
                TextField("AccountName", text: self.$presenter.accountName)
                    .multilineTextAlignment(.center)
                    .autocapitalization(.none)
                    .onReceive(Just(self.presenter.accountName)) { _ in
                        //最大文字数を超えたら、最大文字数までの文字列を代入する
                        if self.presenter.accountName.count > 20 {
                            self.presenter.accountName = String(self.presenter.accountName.prefix(20))
                        }
                    }
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
                            FriendListItem(name: friend.name, avatarImage: friend.getAvatarImageFromImageData())
                        }
                    }
                } header: {
                    Text("FriendListHeader")
                }

                Section {
                    Button {
                        self.presenter.onAddFriendButtonTap()
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
                    Button {
                        self.presenter.onSignOutButtonTapped(auth: self.auth)
                    } label: {
                        HStack {
                            Spacer()
                            Text("SignOutButton")
                            Spacer()
                        }
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        self.presenter.onDeleteAccountButtonTapped(auth: self.auth)
                    } label: {
                        HStack {
                            Spacer()
                            Text("DeleteAccountButton")
                            Spacer()
                        }
                    }
                }
                
            }
            
            if !(self.appDelegate.locationAuthorizationStatus == .authorizedAlways || self.appDelegate.locationAuthorizationStatus == .authorizedWhenInUse) {
                VStack(alignment: .trailing) {
                    HStack {
                        Text("AccessToLocationIsNotAllowed1")
                            .font(.footnote)
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        
                        if ["ja_US", "ja_JP"].contains(Locale.current.identifier) {
                            Link("AccessToLocationIsNotAllowed2", destination: URL(string: UIApplication.openSettingsURLString)!)
                                .font(.footnote)
                                .padding(.vertical, 1)
                            Text("AccessToLocationIsNotAllowed3")
                                .font(.footnote)
                        } else {
                            Text("AccessToLocationIsNotAllowed3")
                                .font(.footnote)
                            Link("AccessToLocationIsNotAllowed2", destination: URL(string: UIApplication.openSettingsURLString)!)
                                .font(.footnote)
                                .padding(.vertical, 1)
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color("MainColor").opacity(0.5))
            }
        }
        .alert("DeleteAccountAlertTitle",
               isPresented: self.$presenter.showingDeleteAccountAlert) {
            Button("DeleteAccountAlertButton", role: .destructive) {
                self.presenter.onDeleteAccountAlertButtonTapped(auth: self.auth)
            }
            Button(NSLocalizedString("DeleteAccountAlertCancelButton", comment: ""), role: .cancel) {
                
            }
        } message: {
            Text("DeleteAccountAlertMessage")
        }
        .alert("DeleteAccountFailedAlertTitle",
               isPresented: self.$presenter.showingDeleteAccountFailedAlert) {
            Button("DeleteAccountFailedAlertButton") { }
        } message: {
            Text("DeleteAccountFailedAlertMessage")
        }
        .sheet(isPresented: self.$presenter.showingQrCodeSheet) {
            NavigationView {
                self.presenter.makeAboutMyQrCodeView()
            }
        }
        .fullScreenCover(isPresented: self.$presenter.showingQrCodeScannerSheet) {
            NavigationView {
                self.presenter.makeAboutTeamQrCodeScannerView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                self.presenter.onQrCodeScannerBackButtonTap()
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                        }
                    }
            }
        }
        .popup(isPresented: self.$presenter.showingResultFloater,
               type: .floater(verticalPadding: 40),
               position: .top,
               autohideIn: 3.0) {
            ResultFloater(text: self.presenter.resultFloaterText)
        }

        .onAppear {
            self.presenter.onAppear()
        }
        .onDisappear {
            self.presenter.onDisappear()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let auth = Authentication()
    static let appDelegate = AppDelegate()
    
    static var previews: some View {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router, uid: "")
        presenter.accountName = "マイアカウント"
        presenter.friends = [Avatar(id: "1", name: "友だち１"),
                             Avatar(id: "2", name: "友だち２")]
        
        return ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                HomeView(presenter: presenter)
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
                    .environmentObject(appDelegate)
                    .environmentObject(auth)
            }
        }
    }
}
