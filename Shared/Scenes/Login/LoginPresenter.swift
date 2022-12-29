//
//  LoginPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/19.
//

import Foundation
import Firebase
import FirebaseAuth

final class LoginPresenter: ObservableObject {
    
    private let interactor: LoginUsecase
    private let router: LoginWireframe
    
    init(interactor: LoginUsecase, router: LoginWireframe) {
        self.interactor = interactor
        self.router = router
    }
}

extension LoginPresenter {
    func signedIn(auth: Authenticatable, authCredential: AuthCredential?) {
        guard let authCredential = authCredential else {
            return
        }

        auth.signIn(credential: authCredential)
    }
    
    func createAccount(auth: Authenticatable) {
        auth.createUser()
    }
    
    func cancelAccountCreation(auth: Authenticatable) {
        // profileは作成されていないが、firebase上のユーザは作成されているため、削除する
        auth.deleteFirebaseUser() { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func agreeAccountCreationFailed(auth: Authenticatable) {
        auth.signOut()
    }
}
