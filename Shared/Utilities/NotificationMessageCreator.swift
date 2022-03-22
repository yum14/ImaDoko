//
//  NotificationMessageCreator.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/22.
//

import Foundation

class NotificationMessageCreator {
    
    static func createImakokoMessage(fromId: String, fromName: String, toIds: [String]) -> Notification {
        let title = "イマココ"
        let body = fromName + "さんからのイマココ"
        return Notification(fromId: fromId, title: title, body: body, toIds: toIds)
    }
    
    static func createImadokoMessage(fromId: String, fromName: String, toIds: [String]) -> Notification {
        let title = "イマドコ"
        let body = fromName + "さんからのイマドコ"
        return Notification(fromId: fromId, title: title, body: body, toIds: toIds)
    }
}
