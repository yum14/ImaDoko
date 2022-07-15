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
    
    private static let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088), span: coordinateSpan) {
        didSet {
            print("変更後2")
            print(String(self.region.center.latitude))
            print(String(self.region.center.longitude))
        }
    }
    @Published var friends: [Avatar] = []
    @Published var pinItems: [PinItem] = []
    @Published var notch: Notch = .min
    @Published var selectedFriendIds: [String] = []
    @Published var overlaySheetType: OverlaySheetType = .close
    @Published var showingMessageSheet = false
    @Published var unrepliedButtonBadgeText: String?
    
    private var unrepliedMessageCount: Int = 0 {
        didSet {
            if self.unrepliedMessageCount > 0 {
                self.unrepliedButtonBadgeText = String(self.unrepliedMessageCount)
            } else {
                self.unrepliedButtonBadgeText = nil
            }
        }
    }
    
    private var firstAppear = true
    
    private var friendProfiles: [Profile] = [] {
        didSet {
            let newFriends = self.friendProfiles.map { Avatar(id: $0.id, name: $0.name, avatarImageData: self.friendImages[$0.id]) }
            self.friends = newFriends
            
            if self.locations.count == 0 {
                return
            }
            
            let newPinItems = self.locations
                .filter { location in
                    self.friends.contains(where: { $0.id == location.userId })
                }
                .map { location in
                    PinItem(id: location.userId,
                            coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                            imageData: self.friendImages[location.userId],
                            createdAt: location.createdAt.dateValue())}
            
            self.pinItems = newPinItems
        }
    }
    private var friendImages: [String: Data] = [:] {
        didSet {
            let newFriends = self.friendProfiles.map { Avatar(id: $0.id, name: $0.name, avatarImageData: self.friendImages[$0.id]) }
            self.friends = newFriends
            
            if self.pinItems.count == 0 {
                return
            }
            
            let newPinItems = self.pinItems.map { PinItem(id: $0.id, coordinate: $0.coordinate, imageData: self.friendImages[$0.id], tint: $0.tint, createdAt: $0.createdAt) }
            
            self.pinItems = newPinItems
        }
    }
    
    private var locations: [Location] = [] {
        didSet {
            if self.locations.count == 0 {
                self.pinItems = []
                return
            }
            
            
            let newPinItems = locations
                .filter { location in
                    self.friends.contains(where: { $0.id == location.userId })
                }
                .map { location in
                    PinItem(id: location.userId,
                            coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                            imageData: self.friendImages[location.userId],
                            createdAt: location.createdAt.dateValue())}
            
            self.pinItems = newPinItems
        }
    }
    
    var profile: Profile?
    private let interactor: MapUsecase
    private let router: MapWireframe
    private let uid: String
    private var selectedPinItem: PinItem?
    
    init(interactor: MapUsecase, router: MapWireframe, uid: String) {
        self.interactor = interactor
        self.router = router
        self.uid = uid
        
        self.addListner()
    }
    
    deinit {
        self.removeListener()
    }
}

extension MapPresenter {
    
    private func addListner() {
        
        self.interactor.addLocationListener(ownerId: self.uid) { result in
            switch result {
            case .success(let locations):
                if let locations = locations {
                    self.locations = locations
                } else {
                    self.locations = []
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // イマドコメッセージのリスナー作成
        self.interactor.addImadokoMessageListener(ownerId: self.uid) { result in
            switch result {
            case .success(let imadokoMessages):
                guard let imadokoMessages = imadokoMessages else {
                    self.unrepliedMessageCount = 0
                    return
                }
                
                self.unrepliedMessageCount = imadokoMessages.count
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // プロフィールのリスナー作成
        self.interactor.addProfileListener(id: self.uid) { result in
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
    
    private func removeListener() {
        self.interactor.removeLocationListener()
        self.interactor.removeImadokoMessageListener()
    }
    
    func onAppear(initialRegion: MKCoordinateRegion) {
        if self.firstAppear {
            self.region = initialRegion
            self.firstAppear.toggle()
        }
    }
    
    func onDisapper() {
        self.notch = .min
        self.selectedFriendIds = []
    }
}

extension MapPresenter {
    func onMessageDestinationViewDismiss() {
        withAnimation {
            self.notch = .min
            self.selectedFriendIds = []
        }
    }
    
    func onOverlaySheetTranslation(translation: MagneticNotchOverlayBehavior<Notch>.Translation) {
        // シートを引き下げた際のView変更はここで実施
        // notchChangeで変更された値に応じて実施すると判定が遅く、Viewの動きに違和感があるため
        if translation.progress < 0.2 && self.overlaySheetType != .close {
            withAnimation {
                self.overlaySheetType = .close
            }
        }
    }
    
    func onAvatarMapAnnotationTap(item: PinItem) {
        self.selectedPinItem = item
        
        // タップしたPinをMapのcenterにする
        self.region = MKCoordinateRegion(center: item.coordinate, span: MapPresenter.coordinateSpan)
        
        withAnimation {
            self.overlaySheetType = .pinDetail
            self.notch = .max
        }
    }
    
    func onOverlaySheetBackgroundTap() {
        withAnimation {
            self.overlaySheetType = .close
            self.notch = .min
        }
    }
    
    func onLocationButtonTap(region: MKCoordinateRegion) {
        DispatchQueue.main.async {
            self.region = region
        }
    }
    
    func onUnreadMessageButtonTap() {
        self.showingMessageSheet = true
    }
    
    func onMessageViewBackButtonTap() {
        self.showingMessageSheet = false
    }
}

extension MapPresenter {
    func makeAbountOverlaySheet(resultNotification: ResultNotification, locationAuthorizationStatus: CLAuthorizationStatus) -> some View {
        
        switch self.overlaySheetType {
        case .close:
            return AnyView(SendMessageButton(onTap: {
                withAnimation {
                    self.overlaySheetType = .messageDestination
                    self.notch = .max
                }
            }, disabled: locationAuthorizationStatus == .denied))
        case .messageDestination:
            return self.router.makeMessageDestinationView(myId: profile?.id ?? "", myName: profile?.name ?? "", friends: self.friends, onDismiss: {
                withAnimation {
                    self.overlaySheetType = .close
                    self.notch = .min
                    self.selectedFriendIds = []
                }
            }, onSend: { errors in
                resultNotification.show(text: self.createResultNotificationText(success: errors.count == 0))
            })
        case .pinDetail:
            return self.router.makePinDetailView(myId: self.profile?.id ?? "", myName: self.profile?.name ?? "", friend: self.friends.first(where: { $0.id == self.selectedPinItem!.id })!, createdAt: self.selectedPinItem!.createdAt, onDismiss: {
                withAnimation {
                    self.overlaySheetType = .close
                    self.notch = .min
                    self.selectedFriendIds = []
                }
            }, onSend: { error in
                resultNotification.show(text: self.createResultNotificationText(success: error == nil))
            })
        }
    }
    
    func makeAboutMessageView() -> some View {
        return router.makeMessageView(uid: self.uid)
    }
    
    private func createResultNotificationText(success: Bool) -> String {
        return NSLocalizedString(success ? "SendCompleted" : "SendFailed", comment: "")
    }
}

enum Notch: CaseIterable, Equatable {
    case min, max
}

enum OverlaySheetType {
    case close
    case messageDestination
    case pinDetail
}
