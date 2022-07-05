//
//  ProfileCache.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/13.
//

import Foundation

final class ProfileCache {
    static let shared = ProfileCache()
    private var cache: [Cache] = []
    
    private let serialQueue = DispatchQueue(label: "serialQueue")
    private let timeInterval: TimeInterval = 3600 // 1時間
    
    private init() {}
    
    func set(_ value: Profile?, forKey key: String) {
        self.serialQueue.sync {
            if let index = self.cache.firstIndex(where: { $0.id == key }) {
                self.cache.remove(at: index)
            }
            
            if let value = value {
                self.cache.append(Cache(id: key, limit: Date(timeInterval: 3600, since: .now), data: value))
            }
        }
    }
    
    func get(forKey key: String) -> Profile? {
        self.serialQueue.sync {
            guard let target = self.cache.first(where: { $0.id == key }) else {
                return nil
            }
            
            if target.limit < .now {
                if let index = self.cache.firstIndex(where: { $0.id == key }) {
                    self.cache.remove(at: index)
                }
                return nil
            }
            
            return target.data
        }
    }
    
    private struct Cache: Identifiable {
        var id: String
        var limit: Date
        var data: Profile
    }
}
