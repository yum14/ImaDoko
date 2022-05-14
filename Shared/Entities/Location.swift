//
//  Location.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/17.
//

import Foundation
import Firebase

struct Location: Identifiable, Hashable {
    var id: String
    var userId: String
    var ownerId: String
    var latitude: Double
    var longitude: Double
    var createdAt: Timestamp
    
    init(id: String = UUID().uuidString, userId: String, ownerId: String, latitude: Double, longitude: Double, createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.ownerId = ownerId
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = Timestamp(date: Date())
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["userId"] = self.userId
        dic["ownerId"] = self.ownerId
        dic["latitude"] = self.latitude
        dic["longitude"] = self.longitude
        dic["created_at"] = self.createdAt
        
        return dic
    }
}
