//
//  ImaDoko.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/12.
//

import Foundation

struct Message: Identifiable, Hashable, Codable {
    var id: String
    var fromId: String
    var fromName: String
    var avatarImage: Data?
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         fromId: String,
         fromName: String,
         avatarImage: Data? = nil,
         createdAt: Date = Date()) {
        
        self.id = id
        self.fromId = fromId
        self.fromName = fromName
        self.avatarImage = avatarImage
        self.createdAt = createdAt
    }
}
