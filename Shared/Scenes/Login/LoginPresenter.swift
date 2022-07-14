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
    func signedIn(auth: Authenticatable, authCredential: AuthCredential?, completion: ((SignInStatus) -> Void)?) {
        guard let authCredential = authCredential else {
            return
        }

        auth.signIn(credential: authCredential, completion: completion)
    }
    
    func createAccount(auth: Authenticatable) {
        auth.createUser(onCreated: { _ in })
    }
    
    func cancelAccountCreation(auth: Authenticatable) {
        auth.signOut()
    }
    
    func agreeAccountCreationFailed(auth: Authenticatable) {
        auth.signOut()
    }
}
