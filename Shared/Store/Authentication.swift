//
//  Authentication.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/19.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFunctions
import FirebaseCore

protocol Authenticatable {
    func signIn(credential: AuthCredential)
    func signOut()
    func createUser()
    func deleteUser(completion: ((Error?) -> Void)?)
    func deleteFirebaseUser(completion: ((Error?) -> Void)?)
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
    private var signInHistoriesStore: SignInHistoriesStore
    private var notAuthenticationStateDidChangeListenListen = false
    
    var firebaseLoginUser: Firebase.User?
    var authCredential: AuthCredential?
    var profile: Profile?
    
    override init() {
        self.profileStore = ProfileStore()
        self.locationStore = LocationStore()
        self.signInHistoriesStore = SignInHistoriesStore()
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
                if let profile = profile {
                    self.createProfile(profile: profile)
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

    private func createProfile(profile: Profile) {
    
        self.createProfileAndSignInHistory(profile) { error in
            if let error = error {
                print(error.localizedDescription)
                self.signInStatus = .failed
                return
            }
            
            self.profile = profile
            self.signInStatus = .signedIn
        }
    }
    
    
    private func createProfileAndSignInHistory(_ data: Profile, completion: ((Error?) -> Void)?) {
        self.profileStore.setData(data) { error in
            if let error = error {
                completion?(error)
                return
            }
            
            self.signInHistoriesStore.setData(SignInHistory(id: data.id)) { error in
                if let error = error {
                    completion?(error)
                    return
                }
        
                completion?(nil)
            }
        }
    }
    
    private func onIdTokenForcingRefresh(authToken: String?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        self.authToken = authToken
    }
    
    private func getAppleRefreshToken(authenticationCode: String, completion: ((String?, Error?) -> Void)?) {

        let functions = Functions.functions(region: "asia-northeast1")
        functions.httpsCallable("getRefreshToken").call(["code": authenticationCode]) { result, error in
            if let error = error {
                completion?(nil, error)
                return
            }
            
            if let data = result?.data as? String {
                completion?(data, nil)
                return
            } else {
                completion?(nil, nil)
            }
        }
    }
    
    private func revokeAppleToken(refreshToken: String, completion: ((Error?) -> Void)?) {
        
        let functions = Functions.functions(region: "asia-northeast1")
        functions.httpsCallable("revokeToken").call(["refresh_token": refreshToken]) { result, error in
            if let error = error {
                completion?(error)
                return
            }
            
            completion?(nil)
        }
    }
}

extension Authentication: Authenticatable {
    func signIn(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authDataResult, error in
            if let error = error {
                print(error.localizedDescription)
                self.authCredential = nil
                return
            }
            
            self.authCredential = credential
        }
    }
    
    func signOut() {
        let result = Result {
            try Auth.auth().signOut()
        }
        
        switch result {
        case .success():
            self.authCredential = nil
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func createUser() {
        guard let firebaseLoginUser = self.firebaseLoginUser, let authCredential = self.authCredential else {
            return
        }
        
        if authCredential.provider == "apple.com" {
            guard let authenticationCode = authCredential.value(forKey: "accessToken") as? String else {
                return
            }
            
            self.getAppleRefreshToken(authenticationCode: authenticationCode) { refreshToken, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let refreshToken = refreshToken else {
                    return
                }
                
                let newProfile = Profile(id: firebaseLoginUser.uid, name: firebaseLoginUser.displayName ?? NSLocalizedString("NewDefaultUserName", comment: ""), appleRefreshToken: refreshToken, createdAt: Timestamp(date: Date()))
                self.createProfile(profile: newProfile)
            }
        } else {
         
            let newProfile = Profile(id: firebaseLoginUser.uid, name: firebaseLoginUser.displayName ?? NSLocalizedString("NewDefaultUserName", comment: ""), appleRefreshToken: nil, createdAt: Timestamp(date: Date()))
            self.createProfile(profile: newProfile)
        }
    }
    
    func deleteUser(completion: ((Error?) -> Void)?) {
        guard let profile = self.profile else {
            return
        }
        
        self.deleteFirebaseUser() { error in
            if let error = error {
                completion?(error)
                return
            }
            
            if let refreshToken = profile.appleRefreshToken {
                // Sign in with Appleのトークン無効化
                self.revokeAppleToken(refreshToken: refreshToken) { error in
                    if let error = error {
                        completion?(error)
                        return
                    }
                    
                    self.authCredential = nil
                    completion?(nil)
                }
            } else {
                self.authCredential = nil
                completion?(nil)
            }
        }
    }
    
    func deleteFirebaseUser(completion: ((Error?) -> Void)?) {
        
        guard let firebaseLoginUser = self.firebaseLoginUser else {
            return
        }
        
        // firebaseユーザ(firebase authentication）の削除
        // firestoreの関連データも削除したいところだが、ユーザ削除に成功した場合は、権限がなくなるため削除不可能
        // だからといって先にfirestoreデータを削除してしまうと、Firebase Authenticationのユーザ削除に失敗した場合（しばらいサインインしていない場合など）に立て直しが不可能
        // よって、firebase functionによってfirestoreデータは削除することとする
        firebaseLoginUser.delete { error in
            if let error = error {
                completion?(error)
                return
            }
            
            completion?(nil)
        }
    }
}
