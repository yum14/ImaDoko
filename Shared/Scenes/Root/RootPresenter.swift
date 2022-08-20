//
//  RootPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI
import MapKit

final class RootPresenter: ObservableObject {
    @Published var tabSelection: Int = 1
    var receivedNotification: ReceivedNotification? {
        didSet {
            if self.receivedNotification != nil {
                self.showingNotificationPopup = true
            }
        }
    }
    @Published var showingNotificationPopup = false
    
    
    var homeView: AnyView?
    var mapView: AnyView?
    var uidOnHomeView: String?
    var uidOnMapView: String?
    
    private let interactor: RootUsecase
    private let router: RootWireframe
    
    private var notificationUserId: String?
    
    init(interactor: RootUsecase, router: RootWireframe) {
        self.interactor = interactor
        self.router = router
    }
}

extension RootPresenter {
    func onAppear(uid: String, notificationToken: String) {
        self.interactor.setNotificationToken(data: NotificationToken(id: uid, notificationToken: notificationToken)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
//        let yesterday = Date().addingTimeInterval(-60*60*24)
//        
//        // 期限切れデータを削除
//        self.interactor.deleteExpiredData(ownerId: uid, deadline: yesterday)
    }
    
    func onOpenUrl(url: URL) {
        guard let host = url.host, let queryUrlComponents = URLComponents(string: url.absoluteString) else {
            return
        }
        
        guard let userId = queryUrlComponents.queryItems?.first(where: { $0.name == "id" })?.value,
              let userName = queryUrlComponents.queryItems?.first(where: { $0.name == "name" })?.value else {
            return
        }
        
        if host == "imadoko" {
            // avatarImageを取得
            self.interactor.getAvatarImage(id: userId) { result in
                switch result {
                case .success(let image):
                    self.tabSelection = 2
                    self.receivedNotification = ReceivedNotification(id: userId, name: userName, avatarImageData: image?.data, type: host == "imadoko" ? .imadoko : .kokodayo)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            // kokodayoではreceivedNotificationは作らない（使わないので）
            self.tabSelection = 2
        }
        
        self.notificationUserId = userId
    }
    
    func onImadokoNotificationReply(id: String, location: CLLocationCoordinate2D) {
        guard let friendId = self.notificationUserId else {
            self.showingNotificationPopup = false
            return
        }
        
        // イマドコ通知元のユーザのデータとして、自分のロケーションを追加する
        let location = Location(userId: id, ownerId: friendId, latitude: location.latitude, longitude: location.longitude)
        
        self.interactor.setLocation(location) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        
        // TODO: イマドコ通知を既読にする
        
        
        
        self.showingNotificationPopup = false
    }
    
    func onImadokoNotificationDismiss() {
        self.showingNotificationPopup = false
    }
    
    
    func makeAboutLoginView() -> some View {
        return router.makeLoginView()
    }
    
    func makeAboutMapView(uid: String) -> some View {
       
//        return router.makeMapView(uid: uid)
        
        // タブを切り替えるたびにMapViewのイニシャライズを走らせたくないため、キャッシュ化する
        if self.mapView != nil && uid == self.uidOnMapView {
            return self.mapView!
        } else {
            self.mapView = router.makeMapView(uid: uid)
            self.uidOnMapView = uid

            return self.mapView!
        }
    }
    
    func makeAboutHomeView(uid: String) -> some View {

        // タブを切り替えるたびにHomeViewのイニシャライズを走らせたくないため、キャッシュ化する
        if self.homeView != nil && uid == self.uidOnHomeView {
            return self.homeView!
        } else {
            self.homeView = router.makeHomeView(uid: uid)
            self.uidOnHomeView = uid

            return self.homeView!
        }
    }
}
