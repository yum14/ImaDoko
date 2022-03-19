//
//  MyLocations.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/17.
//

import Foundation
import Firebase

struct MyLocations: Identifiable, Hashable {
    var id: String
    var locations: [Location]
    
    init(id: String, locations: [Location]) {
        self.id = id
        self.locations = locations
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["locations"] = self.locations.map { $0.toDictionary() }
        
        return dic
    }
}

struct Location: Identifiable, Hashable {
    var id: String
    var latitude: Double
    var longitude: Double
    var createdAt: Timestamp
    
    init(id: String, latitude: Double, longitude: Double) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = Timestamp(date: Date())
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["latitude"] = self.latitude
        dic["longitude"] = self.longitude
        dic["created_at"] = self.createdAt
        
        return dic
    }
}
