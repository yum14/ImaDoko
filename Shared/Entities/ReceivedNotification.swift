//
//  ReceivedNotification.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/28.
//

import Foundation
import UIKit

struct ReceivedNotification: Identifiable {
    var id: String
    var name: String
    var avatarImageData: Data?
    var avatarImage: UIImage? {
        guard let data = self.avatarImageData else {
            return nil
        }
        
        return UIImage(data: data)
    }
    var type: ReceivedNotificationType
}

enum ReceivedNotificationType {
    case imadoko
    case kokodayo
}
