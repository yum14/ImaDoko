//
//  ImadokoMessage.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/21.
//

import Foundation
import Firebase

struct ImadokoMessage: Identifiable, Hashable {
    var id: String
    var fromId: String
    var toId: String
    var replyed: Bool
    var createdAt: Timestamp
    
    init(id: String = UUID().uuidString,
         fromId: String,
         toId: String,
         replyed: Bool = false,
         createdAt: Date = Date()) {
        self.id = id
        self.fromId = fromId
        self.toId = toId
        self.replyed = replyed
        self.createdAt = Timestamp(date: createdAt)
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["from_id"] = self.fromId
        dic["to_id"] = self.toId
        dic["replyed"] = self.replyed
        dic["created_at"] = self.createdAt
        
        return dic
    }
}
