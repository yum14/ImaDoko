//
//  HomePresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation

final class HomePresenter: ObservableObject {
    @Published var accountName = ""
    @Published var friends: [User] = []
    
    private let router: HomeWireframe
    
    init(router: HomeWireframe) {
        self.router = router
    }
}

extension HomePresenter {
    
}
