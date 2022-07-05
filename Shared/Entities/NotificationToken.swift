//
//  NotificationToken.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/26.
//

import Foundation
import Firebase

struct NotificationToken: Identifiable, Hashable {
    var id: String
    var notificationToken: String?
    
    init(id: String, notificationToken: String?) {
        self.id = id
        self.notificationToken = notificationToken
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["notification_token"] = self.notificationToken
        
        return dic
    }
}
