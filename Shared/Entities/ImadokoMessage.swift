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
    var userId: String
    var ownerId: String
    var replyed: Bool
    var createdAt: Timestamp
    
    init(id: String = UUID().uuidString,
         userId: String,
         ownerId: String,
         replyed: Bool = false,
         createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.ownerId = ownerId
        self.replyed = replyed
        self.createdAt = Timestamp(date: createdAt)
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["user_id"] = self.userId
        dic["owner_id"] = self.ownerId
        dic["replyed"] = self.replyed
        dic["created_at"] = self.createdAt
        
        return dic
    }
}
