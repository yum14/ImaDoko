//
//  User.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/20.
//

import Foundation

struct User: Identifiable, Hashable, Codable {
    var id: String
    var email: String?
    var photoUrl: String?
    var notificationToken: String?
    
    init(id: String = UUID().uuidString, email: String? = nil, photoUrl: String? = nil, notificationToken: String? = nil) {
        self.id = id
        self.email = email
        self.photoUrl = photoUrl
        self.notificationToken = notificationToken
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case photoUrl = "photo_url"
        case notificationToken = "notification_token"
    }
}
