//
//  Friend.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/12.
//

import Foundation

struct User: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var avatorImage: Data?
    var createdAt: Date
    var updatedAt: Date?
    
    init(id: String = UUID().uuidString,
         name: String,
         avatorImage: Data? = nil,
         createdAt: Date = Date(),
         updatedAt: Date? = nil) {
        
        self.id = id
        self.name = name
        self.avatorImage = avatorImage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
