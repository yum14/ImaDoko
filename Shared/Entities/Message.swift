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
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         from: String,
         createdAt: Date = Date()) {
        
        self.id = id
        self.from = from
        self.createdAt = createdAt
    }
}
