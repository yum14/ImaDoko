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
    @Published var pinItems: [PinItem] = []
    @Published var notch: Notch = .min {
        didSet {
            self.editable = (self.notch == .max)
        }
    }
    @Published var editable = false
    @Published var selectedFriendIds: [String] = []
    
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
        
        self.interactor.addMyLocationsListener(id: self.uid) { result in
            switch result {
            case .success(let mylocations):
                if let mylocations = mylocations {
                    
                    if mylocations.locations.count == 0 {
                        self.pinItems = []
                        return
                    }
                    
                    self.interactor.getAvatarImages(ids: mylocations.locations.map { $0.id }) { result in
                        switch result {
                        case .success(let avatarImages):
                            let newPinItems = mylocations.locations
                                .map { location in
                                    PinItem(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                                            imageData: avatarImages?.first(where: { $0.id == location.id })?.data)}
                            
                            self.pinItems = newPinItems
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
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

extension MapPresenter {
    func onImakokoButtonTap(location: CLLocationCoordinate2D) {
        guard let profile = self.profile else {
            return
        }
        
        if !(self.selectedFriendIds.count > 0) {
            return
        }
        
        let location = Location(id: profile.id, latitude: location.latitude, longitude: location.longitude)
        
        // 現在地情報を追加
        for friendId in self.selectedFriendIds {
            self.interactor.appendMyLocation(location, id: friendId) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        // プッシュ通知
        let newData = ImakokoNotification(ownerId: profile.id, ownerName: profile.name, latitude: location.latitude, longitude: location.longitude, to: self.selectedFriendIds)
        
        self.interactor.setImakokoNotification(newData) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        withAnimation {
            self.notch = .min
            self.selectedFriendIds = []
        }
    }
    
    func onImadokoButtonTap() {
        withAnimation {
            self.notch = .min
            self.selectedFriendIds = []
        }
    }
}


enum Notch: CaseIterable, Equatable {
    case min, max
}
