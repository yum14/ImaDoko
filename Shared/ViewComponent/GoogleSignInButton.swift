//
//  GoogleSignInButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/20.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct GoogleSignInButton: View {
    var signedIn: ((AuthCredential?) -> Void)?
    
    var body: some View {
        Button {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                return
            }
            
            let config = GIDConfiguration(clientID: clientID)
            
            GIDSignIn.sharedInstance.signIn(with: config, presenting: self.getRootViewController()) { user, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.signedIn?(nil)
                    return
                }
                guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                    print("authentication error.")
                    self.signedIn?(nil)
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                
                self.signedIn?(credential)
            }
        } label: {
            HStack(spacing: 8) {
                Image("GoogleIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                Text("SignInWithGoogle")
                    .foregroundColor(.black)
                    .fontWeight(.medium)
            }
            .padding(.vertical, 7)
            .frame(width: 280)
            .background(Color.white)
            .cornerRadius(50)
        }

    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["ja_JP", "en_US"], id: \.self) { id in
            GoogleSignInButton()
                .environment(\.locale, .init(identifier: id))
        }

    }
}
