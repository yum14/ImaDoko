//
//  HomePresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation

final class HomePresenter: ObservableObject {
    @Published var accountName = ""
    @Published var friends: [Profile] = [Profile(name: "友だち１"),
                                         Profile(name: "友だち２"),
                                         Profile(name: "友だち３")]
    
    private var profile: Profile? {
        didSet {
            guard let profile = self.profile else {
                return
            }
            
            self.accountName = profile.name
//            self.friends = profile.friends
//            
//            profileを取った後にfriendsのProfileを取得するが、画像データがある以上何度も取りに行きたくない。
//            よって、押さえているコード以外のものがあれば取りに行くようにする。
//            全て取得するのは初回のみにしたい・・。
//            どこでaddlistenerするか、どこで押さえておくか（RootViewでaddするかとか、EnvironmentObjectなどで押さえておくか、など。
            
//              RootViewで取得するようにして、EnvironmentObjectで取得することにする。
//              Homeでfriendが追加や削除された場合、そのEnvironmentObjectのfuncで再取得を行うようにする。
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
    
    func addProfileListener() {
        self.interactor.addProfileListener(id: self.uid) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeProfileListener() {
        self.interactor.removeProfileListener()
    }
}
