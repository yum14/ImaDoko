//
//  AvatarImageCache.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/12.
//

import Foundation

final class AvatarImageCache {
    static let shared = AvatarImageCache()
    var avatarImages: [String: Data] = [:]
    
    private let serialQueue = DispatchQueue(label: "serialQueue")
    
    private init() {}
    
    func set(_ value: Data, forKey key: String) {
        self.serialQueue.sync {
            self.avatarImages[key] = value
        }
    }
    
    func get(forKey key: String) -> Data? {
        self.serialQueue.sync {
            return self.avatarImages[key]
        }
    }
}
