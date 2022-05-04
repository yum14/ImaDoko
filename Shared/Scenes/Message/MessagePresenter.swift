//
//  MessagePresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation

final class MessagePresenter: ObservableObject {
    @Published var messageTypeSelection = 0
    @Published var unreadMessages: [Message] = [Message(from: "友だち１", createdAt: .now),
                                                Message(from: "友だち２", createdAt: .now + 20)]
    
    private let router: MessageWireframe
    private let uid: String
    
    init(router: MessageWireframe, uid: String) {
        self.router = router
        self.uid = uid
    }
}
