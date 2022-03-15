//
//  MapPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI
import MapKit
import DynamicOverlay

final class MapPresenter: ObservableObject {
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
    @Published var pinItems: [PinItem] = [PinItem(coordinate: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088))]
    @Published var notch: Notch = .min {
        didSet {
            self.editable = (self.notch == .max)
        }
    }
    @Published var editable = false
    
    private var profile: Profile?
    private let interactor: MapUsecase
    private let router: MapWireframe
    private let uid: String
    
    init(interactor: MapUsecase, router: MapWireframe, uid: String) {
        self.interactor = interactor
        self.router = router
        self.uid = uid
    }
}

extension MapPresenter {
    func onAppear() {
        
        self.interactor.getProfile(id: self.uid) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                
                guard let profile = profile else {
                    return
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
}


enum Notch: CaseIterable, Equatable {
    case min, max
}
