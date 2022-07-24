//
//  KokodayoNotificationMessage.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/07/20.
//

import Foundation

struct KokodayoNotificationMessage: Identifiable {
    var id: String
    var fromId: String
    var fromName: String
    var avatarImage: Data?
    var createdAt: Date
    
    init(id: String = UUID().uuidString, fromId: String, fromName: String, avatarImage: Data?, createdAt: Date) {
        self.id = id
        self.fromId = fromId
        self.fromName = fromName
        self.avatarImage = avatarImage
        self.createdAt = createdAt
    }
}
