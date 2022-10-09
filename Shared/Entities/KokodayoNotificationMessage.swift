//
//  KokodayoNotificationMessage.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/07/20.
//

import Foundation
import UIKit

struct KokodayoNotificationMessage: Identifiable {
    var id: String
    var fromId: String
    var fromName: String
    var avatarImage: Data?
    var latitude: Double
    var longitude: Double
    var createdAt: Date
    
    init(id: String = UUID().uuidString, fromId: String, fromName: String, avatarImage: Data?, latitude: Double, longitude: Double, createdAt: Date) {
        self.id = id
        self.fromId = fromId
        self.fromName = fromName
        self.avatarImage = avatarImage
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
    }
}

extension KokodayoNotificationMessage {
    func getAvatarImageAsUIImage() -> UIImage? {
        guard let avatarImage = self.avatarImage else {
            return nil
        }
        
        return UIImage(data: avatarImage)
    }
}
