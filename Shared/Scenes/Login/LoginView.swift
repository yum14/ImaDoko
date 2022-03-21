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
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        ZStack {
            Color("MainColor")
                .edgesIgnoringSafeArea(.all)
          
            VStack {
                GoogleSignInButton { authCredential in
                    self.presenter.signedIn(auth: self.authentication,
                                            authCredential: authCredential)
                }
                AppleSignInButton { authCredential in
                    self.presenter.signedIn(auth: self.authentication,
                                            authCredential: authCredential)
                }
            }
            .alert("CreateNewUserAlertTitle",
                   isPresented: self.$presenter.showCreateNewAccountAlert) {
                Button("CreateButton") { 
                    self.presenter.createAccount(auth: self.authentication)
                }
                Button(NSLocalizedString("CencelButton", comment: ""), role: .cancel) {
                    self.presenter.cancelAccountCreation(auth: self.authentication)
                }
            } message: {
                Text("CreateNewUserAlertMessage")
            }
            .alert("SignInFailedAlertTitle",
                   isPresented: self.$presenter.showSignInFailedAlert) {
                Button("OKButton") {
                    self.presenter.agreeAccountCreationFailed(auth: self.authentication)
                }
            } message: {
                Text("SignInFailedAlertMessage")
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
