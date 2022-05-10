//
//  ImaDoko.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/12.
//

import Foundation

struct Message: Identifiable, Hashable, Codable {
    var id: String
    var from: String
    var avatarImage: Data?
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         from: String,
         avatarImage: Data? = nil,
         createdAt: Date = Date()) {
        
        self.id = id
        self.from = from
        self.avatarImage = avatarImage
        self.createdAt = createdAt
    }
}
