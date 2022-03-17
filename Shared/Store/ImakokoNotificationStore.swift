//
//  ImakokoNotificationStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/16.
//

import Foundation
import Firebase

final class ImakokoNotificationStore {
    private var db: Firestore?
    private let collectionName = "imakoko_notifications"
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func setData(_ data: ImakokoNotification, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }
}
