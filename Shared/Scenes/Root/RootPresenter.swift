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
    @Published var tabSelection: Int = 2
    @Published var receivedNotification: ReceivedNotification? {
        didSet {
            if self.receivedNotification != nil {
                self.showingNotificationPopup = true
            }
        }
    }
    @Published var showingNotificationPopup = false
    
    private let interactor: RootUsecase
    private let router: RootWireframe
    
    private var notificationUserId: String?
    
    init(interactor: RootUsecase, router: RootWireframe) {
        self.interactor = interactor
        self.router = router
    }
}

extension RootPresenter {
    func setNotificationToken(id: String, notificationToken: String) {
        self.interactor.setNotificationToken(data: NotificationToken(id: id, notificationToken: notificationToken)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func onOpenUrl(url: URL) {
        guard let host = url.host, let queryUrlComponents = URLComponents(string: url.absoluteString) else {
            return
        }
        
        guard let userId = queryUrlComponents.queryItems?.first(where: { $0.name == "id" })?.value,
              let userName = queryUrlComponents.queryItems?.first(where: { $0.name == "name" })?.value else {
            return
        }
        
        // avatarImageを取得
        self.interactor.getAvatarImage(id: userId) { result in
            switch result {
            case .success(let image):
                self.tabSelection = 2
                self.receivedNotification = ReceivedNotification(id: userId, name: userName, avatarImageData: image?.data, type: host == "imadoko" ? .imadoko : .imakoko)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        self.notificationUserId = userId
    }
    
    func onImadokoNotificationReply(id: String, location: CLLocationCoordinate2D) {
        guard let friendId = self.notificationUserId else {
            return
        }
        
        let location = Location(id: id, latitude: location.latitude, longitude: location.longitude)
        
        // イマドコ通知元のユーザのデータとして、自分のロケーションを追加する
        self.interactor.appendMyLocation(location, id: friendId) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        self.showingNotificationPopup = false
    }
    
    func onImadokoNotificationDismiss() {
        self.showingNotificationPopup = false
    }
    
    
    func makeAboutLoginView() -> some View {
        return router.makeLoginView()
    }
    
    func makeAboutMapView(uid: String) -> some View {
        return router.makeMapView(uid: uid)
    }
    
    func makeAboutHomeView(uid: String) -> some View {
        return router.makeHomeView(uid: uid)
    }
    
    func makeAboutMessageView(uid: String) -> some View {
        return router.makeMessageView(uid: uid)
    }
}
