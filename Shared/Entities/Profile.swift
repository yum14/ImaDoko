//
//  Profile.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/12.
//

import Foundation
import Firebase

struct Profile: Identifiable, Hashable {
    var id: String
    var name: String
    var friends: [String]
    var appleRefreshToken: String?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(id: String = UUID().uuidString,
         name: String,
         friends: [String] = [],
         appleRefreshToken: String?,
         createdAt: Timestamp? = nil,
         updatedAt: Timestamp? = nil) {
        
        self.id = id
        self.name = name
        self.friends = friends
        self.appleRefreshToken = appleRefreshToken
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["name"] = self.name
        dic["friends"] = self.friends
        dic["apple_refresh_token"] = self.appleRefreshToken
        dic["created_at"] = self.createdAt
        self.updatedAt != nil ? dic["updated_at"] = self.updatedAt : nil
        
        return dic
    }
}
