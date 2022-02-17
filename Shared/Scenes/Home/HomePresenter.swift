//
//  HomePresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation

final class HomePresenter: ObservableObject {
    @Published var accountName = ""
    @Published var friends: [User] = [User(name: "友だち１"),
                                      User(name: "友だち２"),
                                      User(name: "友だち３")]
    
    private let router: HomeWireframe
    
    init(router: HomeWireframe) {
        self.router = router
    }
}

extension HomePresenter {
    
}
