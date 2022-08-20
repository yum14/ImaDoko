//
//  KokodayoMessage.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/07/16.
//

import Foundation
import Firebase

struct KokodayoMessage: Identifiable, Hashable {
    var id: String
    var toId: String
    var fromId: String
    var latitude: Double
    var longitude: Double
    var isRead: Bool
    var createdAt: Timestamp
    
    init(id: String = UUID().uuidString, fromId: String, toId: String, latitude: Double, longitude: Double, isRead: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.toId = toId
        self.fromId = fromId
        self.latitude = latitude
        self.longitude = longitude
        self.isRead = isRead
        self.createdAt = Timestamp(date: createdAt)
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["from_id"] = self.fromId
        dic["to_id"] = self.toId
        dic["latitude"] = self.latitude
        dic["longitude"] = self.longitude
        dic["is_read"] = self.isRead
        dic["created_at"] = self.createdAt
        
        return dic
    }
}
