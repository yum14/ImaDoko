//
//  HomePresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI
import MapKit

final class HomePresenter: ObservableObject {
    @Published var accountName = ""
    
    @Published var friends: [Avatar] = []
    private var friendProfiles: [Profile] = [] {
        didSet {
            let newFriends = self.friendProfiles.map { Avatar(id: $0.id, name: $0.name, avatarImageData: self.friendImages[$0.id]) }
            self.friends = newFriends
        }
    }
    private var friendImages: [String: Data] = [:] {
        didSet {
            let newFriends = self.friendProfiles.map { Avatar(id: $0.id, name: $0.name, avatarImageData: self.friendImages[$0.id]) }
            self.friends = newFriends
        }
    }
    
    @Published var avatarImage: UIImage? {
        didSet {
            onAvatarImageChanged(image: self.avatarImage)
        }
    }
    @Published var showingQrCodeSheet = false
    @Published var showingQrCodeScannerSheet = false
    
    private var avatarInitialLoading = false
    private var profile: Profile? {
        didSet {
            guard let profile = self.profile else {
                return
            }
            
            if self.accountName != profile.name {
                self.accountName = profile.name
            }
        }
    }
    
    private let interactor: HomeUsecase
    private let router: HomeWireframe
    private let uid: String
    
    init(interactor: HomeUsecase, router: HomeWireframe, uid: String) {
        self.interactor = interactor
        self.router = router
        self.uid = uid
    }
}

extension HomePresenter {
    
    func onSignOutButtonTapped(auth: Authenticatable) {
        auth.signOut()
    }
    
    func onNameTextSubmit() {
        self.interactor.updateNameOfProfile(id: self.uid, name: self.accountName) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func onAvatarImageChanged(image: UIImage?) {
        if self.avatarInitialLoading {
            self.avatarInitialLoading.toggle()
            return
        }
        
        guard let image = image else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        self.interactor.setAvatarImage(AvatarImage(id: self.uid, data: imageData)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func onMyQrCodeButtonTap() {
        self.showingQrCodeSheet = true
    }
    
    func onAddFriendButtonTap() {
        self.showingQrCodeScannerSheet = true
    }
    
    func onAppear() {
        self.avatarInitialLoading = true
        
        self.interactor.addProfileListener(id: self.uid) { result in
            switch result {
            case .success(let profile):
                self.profile = profile

                guard let profile = profile else {
                    return
                }
                
                // アバターイメージの取得
                self.interactor.getAvatarImage(id: profile.id) { result in
                    switch result {
                    case .success(let avatarImage):
                        if let avatarImage = avatarImage {
                            self.avatarImage = UIImage(data: avatarImage.data)
                        } else {
                            self.avatarImage = nil
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
                
                if profile.friends.count == 0 {
                    return
                }
                
                // 友だちのprofile情報を取得
                self.interactor.getProfiles(ids: profile.friends) { result in
                    switch result {
                    case .success(let profiles):
                        
                        self.friendProfiles = profiles ?? []
                        self.friendImages = [:]
                        
                        if let profiles = profiles {
                            
                            // アバターイメージの取得
                            for item in profiles {
                                self.interactor.getAvatarImage(id: item.id) { result in
                                    switch result {
                                    case .success(let avatarImage):
                                        
                                        var newFriendImages = self.friendImages
                                        newFriendImages[item.id] = nil
                                        
                                        if let avatarImage = avatarImage {
                                            newFriendImages[item.id] = avatarImage.data
                                        }
                                        
                                        self.friendImages = newFriendImages
                                        
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func onDisappear() {
        self.interactor.removeProfileListener()
    }
    
    func makeAboutMyQrCodeView() -> some View {
        return router.makeMyQrCodeView(uid: self.profile!.id)
    }
    
    func makeAboutTeamQrCodeScannerView(resultNotification: ResultNotification) -> some View {
        return router.makeMyQrCodeScannerView(
            onFound: { code in
                self.showingQrCodeScannerSheet = false
                
                let qrCodeManager = QrCodeManager()
                
//                 // test用
//                let testCode = "https://icu.yum14/ImaDoko/friends/Nyhy3JLqLqMgPA5bAF8NV49Yh4I3"
//                guard let uid = qrCodeManager.getMyAppQrCode(code: testCode) else {
//                    return
//                }
                guard let uid = qrCodeManager.getMyAppQrCode(code: code) else {
                    return
                }
                
                guard let profile = self.profile else {
                    return
                }
                
                if profile.friends.contains(uid) {
                    let message = String(format: NSLocalizedString("AddFriendAlreadyAdded", comment: ""),
                                         self.friendProfiles.first { $0.id == uid }?.name ?? "")
                    resultNotification.show(text: message)
                    return
                }
                
                var newFriends = profile.friends
                newFriends.append(uid)
                
                self.interactor.updateFriendsOfProfile(id: profile.id, friends: newFriends) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        
                        resultNotification.show(text: NSLocalizedString("AddFriendFailed", comment: ""))
                        return
                    }
                }
            },
            onDismiss: { self.showingQrCodeScannerSheet = false })
    }
    
    
    private func IsDifferentAvatarLastValue(newImageData: Data?) -> Bool {
        if let newImageData = newImageData {
            // 比較のために一度Data型とする
            let oldImageData = self.avatarImage?.jpegData(compressionQuality: 0.1)
            
            if oldImageData == nil {
                return true
            } else {
                return newImageData != oldImageData
            }
        } else {
            return self.avatarImage != nil
        }
    }
    
    private func IsDifferentAvatarLastValue(newImage: UIImage?) -> Bool {
        return self.IsDifferentAvatarLastValue(newImageData: newImage?.jpegData(compressionQuality: 0.1))
    }
}

struct FriendImage: Identifiable {
    var id: String
    var name: String
    var avatarImage: Data?
}
