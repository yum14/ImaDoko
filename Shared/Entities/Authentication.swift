//
//  Authentication.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/19.
//

import Foundation
import SwiftUI
import Firebase

protocol Authenticatable {
    func signIn(credential: AuthCredential)
    func signOut()
    func createUser()
    var signInStatus: SignInStatus { get set }
}

enum SignInStatus {
    case notYet
    case signedIn
    case failed
    case newUser
}

final class Authentication: UIResponder, ObservableObject {
    
    @Published var signInStatus: SignInStatus = .notYet
    
    private var listener: AuthStateDidChangeListenerHandle!
    private var authToken: String?
    private var profileStore: ProfileStore
    private var locationStore: LocationStore
    private var notAuthenticationStateDidChangeListenListen = false
    
    var firebaseLoginUser: Firebase.User?
    var profile: Profile?
    
    override init() {
        self.profileStore = ProfileStore()
        self.locationStore = LocationStore()
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(listener)
    }
    
    func addListener() {
        
        self.listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            self.authStateDidChangeListener(auth: auth, user: user)
            
            user?.getIDTokenForcingRefresh(true, completion: self.onIdTokenForcingRefresh)
        }
    }
    
    private func authStateDidChangeListener(auth: Firebase.Auth, user: Firebase.User?) {
        guard let user = user else {
            self.firebaseLoginUser = nil
            self.profile = nil
            self.signInStatus = .failed
            return
        }
        
        self.firebaseLoginUser = user
        
        self.profileStore.getDocument(id: user.uid) { result in
            switch result {
            case .success(let profile):
                if profile != nil {
                    self.profile = profile
                    self.signInStatus = .signedIn
                } else {
                    self.profile = nil
                    self.signInStatus = .newUser
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.profile = nil
                self.signInStatus = .failed
            }
        }
    }
    
    private func onIdTokenForcingRefresh(authToken: String?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        self.authToken = authToken
    }
}

extension Authentication: Authenticatable {
    
    func signIn(credential: AuthCredential) {
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
            print(error.localizedDescription)
        }
    }
    
//    func signIn(credential: AuthCredential, completion: ((SignInStatus) -> Void)?) {
//
//        self.notAuthenticationStateDidChangeListenListen = true
//
//        Auth.auth().signIn(with: credential) { authDataResult, error in
//            if let error = error {
//                print(error.localizedDescription)
//                self.firebaseLoginUser = nil
//                self.profile = nil
//                completion?(.failure)
//                self.notAuthenticationStateDidChangeListenListen = false
//                return
//            }
//
//            guard let authDataResult = authDataResult else {
//                self.firebaseLoginUser = nil
//                self.profile = nil
//                completion?(.failure)
//                self.notAuthenticationStateDidChangeListenListen = false
//                return
//            }
//
//            self.firebaseLoginUser = authDataResult.user
//
//            self.profileStore.getDocument(id: authDataResult.user.uid) { result in
//                switch result {
//                case .success(let profile):
//                    if profile != nil {
//                        self.profile = profile
//                        self.signInProcessing = .signedIn
//                        completion?(.success)
//                    } else {
//                        self.profile = nil
//                        self.signInProcessing = .notSignedIn
//                        completion?(.newUser)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    self.profile = nil
//                    self.signInProcessing = .notSignedIn
//                    completion?(.failure)
//                }
//
//
//                self.notAuthenticationStateDidChangeListenListen = false
//            }
//        }
//    }
//
//    func signOut() {
//
//        self.notAuthenticationStateDidChangeListenListen = true
//
//        let result = Result {
//            try Auth.auth().signOut()
//        }
//
//        switch result {
//        case .success():
//            self.firebaseLoginUser = nil
//            self.profile = nil
//        case .failure(let error):
//            print("signout error. \(error.localizedDescription)")
//            self.firebaseLoginUser = nil
//            self.profile = nil
//        }
//
//        self.notAuthenticationStateDidChangeListenListen = true
//    }
    
    func createUser() {
        guard let firebaseLoginUser = self.firebaseLoginUser else {
            return
        }
        
        let newProfile = Profile(id: firebaseLoginUser.uid, name: firebaseLoginUser.displayName ?? NSLocalizedString("NewDefaultUserName", comment: ""), createdAt: Timestamp(date: Date()))
        
        self.profileStore.setData(newProfile) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.profile = newProfile
            self.signInStatus = .signedIn
        }
    }
}
