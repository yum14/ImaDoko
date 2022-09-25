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
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088), span: coordinateSpan)
    @Published var friends: [Avatar] = []
    @Published var pinItems: [PinItem] = []
    @Published var notch: Notch = .min
    @Published var selectedFriendIds: [String] = []
    @Published var overlaySheetType: OverlaySheetType = .close
    @Published var showingMessageSheet = false
    @Published var unrepliedButtonBadgeText: String?
    @Published var showingImakokoNotification = false
    @Published var showingResultFloater = false
    @Published var showingKokodayoFloater = false
    @Published var showingImadokoFloater = false
    
    var profile: Profile?
    var resultFloaterText: String = ""
    var kokodayoNotificationMessages: [FloaterNotificationMessage] = []
    var imadokoNotificationMessages: [FloaterNotificationMessage] = []
    
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
            
            // MapPinデータ生成
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
        
        // 24時間以内のlocationのみ取得
        self.interactor.addLocationListenerForAdditionalData(ownerId: self.uid, isGreaterThan: Date().addingTimeInterval(-60*60*24)) { result in
            switch result {
            case .success(let locations):
                if let locations = locations {
                    
                    let grouped = Dictionary(grouping: locations, by: { location in
                        location.userId
                    })
                    
                    // ユーザーごとに最新１件のみとする
                    let newLocations = grouped.map { locationByUser in
                        return locationByUser.value.sorted { $0.createdAt.dateValue() > $1.createdAt.dateValue() }.first!
                    }
                    
                    self.locations = newLocations
                } else {
                    self.locations = []
                }
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
        
        // イマドコメッセージのリスナー作成
        self.interactor.addImadokoMessageListenerForAdditionalData(toId: self.uid, isGreaterThan: Date().addingTimeInterval(-60*60*24)) { result in
            switch result {
            case .success(let imadokoMessages):
                guard let imadokoMessages = imadokoMessages else {
                    self.unrepliedMessageCount = 0
                    return
                }
                
                // 対象は1日前まで
                self.unrepliedMessageCount = imadokoMessages.count
                
                if imadokoMessages.count > 0 {
                    let ids = imadokoMessages.map { $0.fromId }
                    
                    // イマドコメッセージ送信元のユーザ名を取得（キャッシュあり）
                    self.interactor.getProfiles(ids: ids) { result in
                        switch result {
                        case .success(let profiles):
                            
                            if let profiles = profiles {
                                // イマドコメッセージ送信元のアバターイメージを取得（キャッシュあり）
                                self.interactor.getAvatarImages(ids: ids) { result in
                                    switch result {
                                    case .success(let avatarImages):
                                        
                                        if let avatarImages = avatarImages {
                                            
                                            // Floater通知メッセージ
                                            let allMessages: [FloaterNotificationMessage] = imadokoMessages.compactMap { message in
                                                
                                                let targetProfile = profiles.first { $0.id == message.fromId }
                                                let targetImage = avatarImages.first { $0.id == message.fromId }
                                                
                                                guard let targetProfile = targetProfile else {
                                                    // ありえないはず
                                                    return nil
                                                }
                                                
                                                return FloaterNotificationMessage(id: message.id,
                                                                                  fromId: message.fromId,
                                                                                  fromName: targetProfile.name,
                                                                                  avatarImage: targetImage?.data,
                                                                                  createdAt: message.createdAt.dateValue())
                                            }
                                            
                                            
                                            // ユーザごとに最新のみとする
                                            let groupingDic = Dictionary(grouping: allMessages, by: { $0.fromId })
                                            let newMessages = groupingDic.map { everyUser in
                                                everyUser.value.sorted(by: { $0.createdAt > $1.createdAt }).first!
                                            }
                                            
                                            self.imadokoNotificationMessages = newMessages
                                            
                                            // イニシャライズ時に読み込まれた場合はここではFloaterは表示しない（できない）
                                            // onAppearにて表示する
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                
                                                if self.imadokoNotificationMessages.count > 0 {
                                                    if self.showingKokodayoFloater == true {
                                                        // ココダヨが表示されている場合は少し待ってから表示する
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                            self.showingImadokoFloater = true
                                                            self.showingKokodayoFloater = false
                                                            self.showingResultFloater = false
                                                        }
                                                    } else {
                                                        self.showingImadokoFloater = true
                                                        self.showingKokodayoFloater = false
                                                        self.showingResultFloater = false
                                                    }
                                                }
                                            }
                                        }
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // ココダヨメッセージのリスナー作成
        self.interactor.addKokodayoMessageListenerForAdditionalData(toId: self.uid, isGreaterThan: Date().addingTimeInterval(-60*60*24)) { result in
            switch result {
            case .success(let kokodayoMessages):
                
                if kokodayoMessages.count > 0 {
                    let ids = kokodayoMessages.map { $0.fromId }
                    
                    // ココダヨッセージ送信元のユーザ名を取得（キャッシュあり）
                    self.interactor.getProfiles(ids: ids) { result in
                        switch result {
                        case .success(let profiles):
                            
                            if let profiles = profiles {
                                // ココダヨメッセージ送信元のアバターイメージを取得（キャッシュあり）
                                self.interactor.getAvatarImages(ids: ids) { result in
                                    switch result {
                                    case .success(let avatarImages):
                                        
                                        if let avatarImages = avatarImages {
                                            
                                            // Locationに追加する
                                            let newLocations = kokodayoMessages.map { Location(userId: $0.fromId,
                                                                                               ownerId: self.uid,
                                                                                               latitude: $0.latitude,
                                                                                               longitude: $0.longitude,
                                                                                               createdAt: $0.createdAt.dateValue())}
                                            
                                            self.interactor.addLocations(locations: newLocations) { error in
                                                if let error = error {
                                                    print(error.localizedDescription)
                                                    return
                                                }
                                                
                                                // 追加済のココダヨを既読にする
                                                self.interactor.updateKokodayoMessageToAlreadyRead(ids: kokodayoMessages.map { $0.id }) { error in
                                                    if let error = error {
                                                        print(error.localizedDescription)
                                                    }
                                                }
                                                
                                                // Floater通知メッセージ
                                                let allMessages: [FloaterNotificationMessage] = kokodayoMessages.compactMap { message in
                                                    
                                                    let targetProfile = profiles.first { $0.id == message.fromId }
                                                    let targetImage = avatarImages.first { $0.id == message.fromId }
                                                    
                                                    guard let targetProfile = targetProfile else {
                                                        // ありえないはず
                                                        return nil
                                                    }
                                                    
                                                    return FloaterNotificationMessage(id: message.id,
                                                                                      fromId: message.fromId,
                                                                                      fromName: targetProfile.name,
                                                                                      avatarImage: targetImage?.data,
                                                                                      createdAt: message.createdAt.dateValue())
                                                }
                                                
                                                
                                                // ユーザごとに最新のみとする
                                                let groupingDic = Dictionary(grouping: allMessages, by: { $0.fromId })
                                                let newMessages = groupingDic.map { everyUser in
                                                    everyUser.value.sorted(by: { $0.createdAt > $1.createdAt }).first!
                                                }
                                                
                                                self.kokodayoNotificationMessages = newMessages
                                                
                                                // イニシャライズ時に読み込まれた場合はここではFloaterは表示しない（できない）
                                                // onAppearにて表示する
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    if self.kokodayoNotificationMessages.count > 0 {
                                                        if self.showingImadokoFloater == true {
                                                            // イマドコが表示されている場合は少し待ってから表示する
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                                self.showingKokodayoFloater = true
                                                                self.showingImadokoFloater = false
                                                                self.showingResultFloater = false
                                                            }
                                                        } else {
                                                            self.showingKokodayoFloater = true
                                                            self.showingImadokoFloater = false
                                                            self.showingResultFloater = false
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func removeListener() {
        self.interactor.removeLocationListener()
        self.interactor.removeImadokoMessageListener()
    }
    
    func onAppear(initialRegion: MKCoordinateRegion) {
        // 再描画のときは呼ばれないので注意
        
        if self.firstAppear {
            self.region = initialRegion
            self.firstAppear.toggle()
        }
        
        // イニシャライズのリスナー追加時にイマココが読み込まれていた場合はここで表示する
        // ※KokodayoFloaterDismissで空にしているが時間差があるため、あえてasyncAfterの中で判定している
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.kokodayoNotificationMessages.count > 0 {
                self.showingKokodayoFloater = true
                self.showingImadokoFloater = false
                self.showingResultFloater = false
            }
            
            if self.imadokoNotificationMessages.count > 0 {
                if self.showingKokodayoFloater == true {
                    // ココダヨが表示されている場合は少し待ってから表示する
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showingImadokoFloater = true
                        self.showingKokodayoFloater = false
                        self.showingResultFloater = false
                    }
                } else {
                    self.showingImadokoFloater = true
                    self.showingKokodayoFloater = false
                    self.showingResultFloater = false
                }
            }
        }
    }
    
    func onDisapper() {
        self.notch = .min
        self.selectedFriendIds = []
        self.showingResultFloater = false
        self.showingKokodayoFloater = false
        self.showingImadokoFloater = false
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
    
    func onKokodayoFloaterDismiss() {
        self.kokodayoNotificationMessages = []
    }
    
    func onImadokoFloaterDismiss() {
        self.imadokoNotificationMessages = []
    }
}

extension MapPresenter {
    func makeAbountOverlaySheet(locationAuthorizationStatus: CLAuthorizationStatus) -> some View {
        
        switch self.overlaySheetType {
        case .close:
            return AnyView(SendMessageButton(onTap: {
                self.overlaySheetType = .messageDestination
                withAnimation {
                    self.notch = .max
                }
            }, disabled: !(locationAuthorizationStatus != .denied && self.friends.count > 0)))
        case .messageDestination:
            return self.router.makeMessageDestinationView(myId: profile?.id ?? "", myName: profile?.name ?? "", friends: self.friends, onDismiss: {
                withAnimation {
                    self.overlaySheetType = .close
                    self.notch = .min
                    self.selectedFriendIds = []
                }
            }, onSend: { errors in
                self.showResultFloater(success: errors.count == 0)
            })
        case .pinDetail:
            return self.router.makePinDetailView(myId: self.profile?.id ?? "", myName: self.profile?.name ?? "", friend: self.friends.first(where: { $0.id == self.selectedPinItem!.id })!, createdAt: self.selectedPinItem!.createdAt, onDismiss: {
                withAnimation {
                    self.overlaySheetType = .close
                    self.notch = .min
                    self.selectedFriendIds = []
                }
            }, onSend: { error in
                self.showResultFloater(success: error == nil)
            })
        }
    }
    
    func makeAboutMessageView() -> some View {
        return router.makeMessageView(uid: self.uid)
    }
    
    private func showResultFloater(success: Bool) {
        self.resultFloaterText = NSLocalizedString(success ? "SendCompleted" : "SendFailed", comment: "")
        self.showingResultFloater = true
        self.showingKokodayoFloater = false
        self.showingImadokoFloater = false
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
