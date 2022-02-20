//
//  LoginView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/19.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var authStateObserver: AuthStateObserver
    
    var body: some View {
        ZStack {
            Color("MainColor")
                .edgesIgnoringSafeArea(.all)
          
            VStack {
                GoogleSignInButton() { authCredential, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    guard let authCredential = authCredential else {
                        print("login failed.")
                        return
                    }
                    
                    self.authStateObserver.signIn(credential: authCredential) { FIRAuthDataResult, error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                LoginView()
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
            }
        }
    }
}
