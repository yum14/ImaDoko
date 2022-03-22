//
//  NotificationStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/16.
//

import Foundation
import Firebase

final class NotificationStore {
    private var db: Firestore?
    private let collectionName = "notifications"
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func setData(_ data: Notification, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }
}
