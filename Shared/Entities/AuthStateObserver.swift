//
//  AuthStateObserver.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/19.
//

import Foundation
import SwiftUI
import Firebase

protocol FirebaseAuthenticatable {
    func signIn(credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void)
    func signOut()
}

final class AuthStateObserver: UIResponder, ObservableObject {
    var notificationToken: String?
    @Published var isSignedIn: Bool = false
    
    private var listener: AuthStateDidChangeListenerHandle!
    private var authToken: String?
    private var firebaseLoginUser: Firebase.User? {
        didSet {
            self.isSignedIn = (self.firebaseLoginUser != nil)
        }
    }
    
    override init() {}
    
    deinit {
        Auth.auth().removeStateDidChangeListener(listener)
    }
    
    func addListener() {
        self.listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.OnStateChanged(auth: auth, user: user)
            
            user?.getIDTokenForcingRefresh(true, completion: self.OnIdTokenForcingRefresh)
        }
    }
    
    private func OnStateChanged(auth: Firebase.Auth, user: Firebase.User?) {
        guard let user = user else {
            self.firebaseLoginUser = nil
            return
        }
        
        self.firebaseLoginUser = user
        
        // TODO: firestoreで持っているtokenを更新する
    }
    
    private func OnIdTokenForcingRefresh(authToken: String?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        self.authToken = authToken
    }
}

extension AuthStateObserver: FirebaseAuthenticatable {
    
    func signIn(credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(with: credential) { authDataResult, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func signOut() {
        let result = Result {
            try Auth.auth().signOut()
        }
        
        switch result {
        case .success():
            break
        case .failure(let error):
            print("signout error. \(error.localizedDescription)")
        }
    }
}
