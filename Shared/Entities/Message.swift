//
//  ImaDoko.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/12.
//

import Foundation

struct Message: Identifiable, Hashable, Codable {
    var id: String
    var userId: String
    var userName: String
    var avatarImage: Data?
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         userId: String,
         userName: String,
         avatarImage: Data? = nil,
         createdAt: Date = Date()) {
        
        self.id = id
        self.userId = userId
        self.userName = userName
        self.avatarImage = avatarImage
        self.createdAt = createdAt
    }
}
