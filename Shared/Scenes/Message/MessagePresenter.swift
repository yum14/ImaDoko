//
//  MessagePresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation

final class MessagePresenter: ObservableObject {
 
    @Published var messageTypeSelection = 0
    @Published var unreadMessages: [Message] = []
    @Published var history: [Message] = []
    
    private let router: MessageWireframe
    
    init(router: MessageWireframe) {
        self.router = router
    }
}
