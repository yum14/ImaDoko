//
//  LoginView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/19.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @ObservedObject var presenter: LoginPresenter
    @EnvironmentObject var auth: Authentication
    
    // 本来はPresenterで持ちたいのだが、AppleでサインインのときにPresenterのフラグを更新して通知がされないためViewに持つ
    @State var showCreateNewAccountAlert = false
    @State var showSignInFailedAlert = false
    
    var body: some View {
        ZStack {
            Color("MainColor")
                .edgesIgnoringSafeArea(.all)
          
            VStack {
                GoogleSignInButton { authCredential in
                    self.presenter.signedIn(auth: self.auth, authCredential: authCredential)
                }
                AppleSignInButton { authCredential in
                    self.presenter.signedIn(auth: self.auth, authCredential: authCredential)
                }
                
            }
            .onChange(of: self.auth.signInStatus) { newValue in
                switch newValue {
                case .signedIn:
                    break
                case .newUser:
                    self.showCreateNewAccountAlert = true
                case .failed:
                    self.showSignInFailedAlert = true
                case .notYet:
                    break
                }
            }
            .alert("CreateNewUserAlertTitle",
                   isPresented: self.$showCreateNewAccountAlert) {
                Button("CreateButton") {
                    self.presenter.createAccount(auth: self.auth)
                }
                Button(NSLocalizedString("CencelButton", comment: ""), role: .cancel) {
                    self.presenter.cancelAccountCreation(auth: self.auth)
                }
            } message: {
                Text("CreateNewUserAlertMessage")
            }
            .alert("SignInFailedAlertTitle",
                   isPresented: self.$showSignInFailedAlert) {
                Button("OKButton") {
                    self.presenter.agreeAccountCreationFailed(auth: self.auth)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static let authentication = Authentication()
    
    static var previews: some View {
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(interactor: interactor, router: router)
        
        ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                LoginView(presenter: presenter)
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
                    .environmentObject(authentication)
            }
        }
    }
}
