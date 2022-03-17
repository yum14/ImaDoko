//
//  ImakokoNotification.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/16.
//

import Foundation
import Firebase

struct ImakokoNotification: Identifiable, Hashable {
    var id: String
    var ownerId: String
    var ownerName: String
    var latitude: Double
    var longitude: Double
    var to: [String]
    var createdAt: Timestamp?
    
    init(id: String = UUID().uuidString,
         ownerId: String,
         ownerName: String,
         latitude: Double,
         longitude: Double,
         to: [String],
         createdAt: Timestamp? = nil) {
        
        self.id = id
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.latitude = latitude
        self.longitude = longitude
        self.to = to
        self.createdAt = createdAt
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["owner_id"] = self.ownerId
        dic["owner_name"] = self.ownerName
        dic["latitude"] = self.latitude
        dic["longitude"] = self.longitude
        dic["to"] = self.to
        dic["created_at"] = self.createdAt        
        return dic
    }
}
