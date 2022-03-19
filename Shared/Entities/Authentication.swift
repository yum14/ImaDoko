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
    func signIn(credential: AuthCredential, completion: ((SignInStatus) -> Void)?)
    func signOut()
    func createUser()
    var isSignedIn: Bool { get set }
}

enum SignInStatus {
    case success
    case failure
    case newUser
}

final class Authentication: UIResponder, ObservableObject {
    @Published var isSignedIn: Bool = false
    
    private var listener: AuthStateDidChangeListenerHandle!
    private var authToken: String?
    private var profileStore: ProfileStore
    private var myLocationsStore: MyLocationsStore
    
    var firebaseLoginUser: Firebase.User? {
        didSet {
            // 不要な通知を防ぐため、変更がある場合のみ設定する
            let newValue = (self.firebaseLoginUser != nil && self.profile != nil)
            if self.isSignedIn != newValue {
                self.isSignedIn = newValue
            }
        }
    }
    var profile: Profile? {
        didSet {
            // 不要な通知を防ぐため、変更がある場合のみ設定する
            let newValue = (self.firebaseLoginUser != nil && self.profile != nil)
            if self.isSignedIn != newValue {
                self.isSignedIn = newValue
            }
        }
    }
    
    override init() {
        self.profileStore = ProfileStore()
        self.myLocationsStore = MyLocationsStore()
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
            return
        }
        
        self.firebaseLoginUser = user
        
        self.profileStore.getDocument(id: user.uid) { result in
            switch result {
            case .success(let profile):
                if profile != nil {
                    self.profile = profile
                } else {
                    self.profile = nil
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.profile = nil
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
    
    func signIn(credential: AuthCredential, completion: ((SignInStatus) -> Void)?) {
        Auth.auth().signIn(with: credential) { authDataResult, error in
            if let error = error {
                print(error.localizedDescription)
                self.firebaseLoginUser = nil
                self.profile = nil
                completion?(.failure)
                return
            }
            
            guard let authDataResult = authDataResult else {
                self.firebaseLoginUser = nil
                self.profile = nil
                completion?(.failure)
                return
            }
            
            self.firebaseLoginUser = authDataResult.user
            
            self.profileStore.getDocument(id: authDataResult.user.uid) { result in
                switch result {
                case .success(let profile):
                    if profile != nil {
                        self.profile = profile
                        completion?(.success)
                    } else {
                        self.profile = nil
                        completion?(.newUser)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.profile = nil
                    completion?(.failure)
                }
            }
        }
    }
    
    func signOut() {
        let result = Result {
            try Auth.auth().signOut()
        }
        
        switch result {
        case .success():
            self.firebaseLoginUser = nil
            self.profile = nil
        case .failure(let error):
            print("signout error. \(error.localizedDescription)")
            self.firebaseLoginUser = nil
            self.profile = nil
        }
    }
    
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
        }
        
        // 空で作成する
        self.myLocationsStore.setData(MyLocations(id: firebaseLoginUser.uid, locations: [])) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
