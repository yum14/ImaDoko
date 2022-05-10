//
//  ImadokoMessages.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/21.
//

import Foundation
import Firebase

struct ImadokoMessages: Identifiable, Hashable {
    var id: String
    var messages: [ImadokoMessage]
    
    init(id: String, messages: [ImadokoMessage]) {
        self.id = id
        self.messages = messages
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["messages"] = self.messages.map { $0.toDictionary() }
        
        return dic
    }
}

struct ImadokoMessage: Identifiable, Hashable {
    var id: String
    var createdAt: Timestamp
    var replyed: Bool
    
    init(id: String) {
        self.id = id
        self.createdAt = Timestamp(date: Date())
        self.replyed = false
    }
    
    init(id: String,
         createdAt: Date,
         replyed: Bool) {
        self.id = id
        self.createdAt = Timestamp(date: createdAt)
        self.replyed = replyed
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["created_at"] = self.createdAt
        dic["replyed"] = self.replyed
        
        return dic
    }
}
