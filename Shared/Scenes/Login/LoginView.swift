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
    @EnvironmentObject var authStateObserver: AuthStateObserver
    
    var body: some View {
        ZStack {
            Color("MainColor")
                .edgesIgnoringSafeArea(.all)
          
            VStack {
                GoogleSignInButton { authCredential in
                    self.presenter.thirdAuthSignedIn(auth: self.authStateObserver,
                                                     authCredential: authCredential)
                }
                AppleSignInButton { authCredential in
                    self.presenter.thirdAuthSignedIn(auth: self.authStateObserver,
                                                     authCredential: authCredential)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static let auth = AuthStateObserver()
    
    static var previews: some View {
        let presenter = LoginPresenter()
        
        ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                LoginView(presenter: presenter)
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
                    .environmentObject(auth)
            }
        }
    }
}
