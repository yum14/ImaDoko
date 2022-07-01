//
//  Notification.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/16.
//

import Foundation
import Firebase

struct Notification: Identifiable, Hashable {
    var id: String
    var fromId: String
    var title: String
    var body: String
    var toIds: [String]
    var createdAt: Timestamp?
    
    init(id: String = UUID().uuidString,
         fromId: String,
         title: String,
         body: String,
         toIds: [String]) {
        
        self.id = id
        self.fromId = fromId
        self.title = title
        self.body = body
        self.toIds = toIds
        self.createdAt = Timestamp(date: Date())
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["from_id"] = self.fromId
        dic["title"] = self.title
        dic["body"] = self.body
        dic["to_ids"] = self.toIds
        dic["created_at"] = self.createdAt        
        return dic
    }
}
