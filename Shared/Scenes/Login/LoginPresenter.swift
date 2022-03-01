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
    @Published var showCreateNewAccountAlert = false
    @Published var showSignInFailedAlert = false
    
    private let router: LoginWireframe
    private let profileStore: ProfileStore
    private var profile: Profile?
    
    init(router: LoginWireframe) {
        self.router = router
        self.profileStore = ProfileStore()
    }
}

extension LoginPresenter {
    func signedIn(auth: Authenticatable, authCredential: AuthCredential?) {
        guard let authCredential = authCredential else {
            return
        }
        
        auth.signIn(credential: authCredential) { signInStatus in   
            switch signInStatus {
            case .success:
                break
            case .newUser:
                self.showCreateNewAccountAlert = true
            case .failure:
                self.showSignInFailedAlert = true
            }
        }
    }
    
    func createAccount(auth: Authentication) {
        auth.createUser()
    }
    
    func cancelAccountCreation(auth: Authentication) {
        auth.signOut()
    }
    
    func agreeAccountCreationFailed(auth: Authentication) {
        auth.signOut()
    }
}
