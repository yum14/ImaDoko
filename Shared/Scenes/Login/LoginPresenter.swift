//
//  LoginPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/19.
//

import Foundation
import FirebaseAuth

final class LoginPresenter: ObservableObject {

}

extension LoginPresenter {
    func thirdAuthSignedIn(auth: FirebaseAuthenticatable, authCredential: AuthCredential?) {
        guard let authCredential = authCredential else {
            print("login failed.")
            return
        }
        
        auth.signIn(credential: authCredential) { FIRAuthDataResult, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
