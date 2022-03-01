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
    var avatorImage: Data?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(id: String = UUID().uuidString,
         name: String,
         avatorImage: Data? = nil,
         createdAt: Timestamp? = nil,
         updatedAt: Timestamp? = nil) {
        
        self.id = id
        self.name = name
        self.avatorImage = avatorImage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["name"] = self.name
        self.avatorImage != nil ? dic["avator_image"] = self.avatorImage : nil
        dic["created_at"] = self.createdAt
        self.updatedAt != nil ? dic["updated_at"] = self.updatedAt : nil
        
        return dic
    }
}
