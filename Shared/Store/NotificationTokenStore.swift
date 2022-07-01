//
//  NotificationTokenStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/26.
//

import Foundation
import Firebase

final class NotificationTokenStore {
    private var db: Firestore?
    private let collectionName = "notification_tokens"
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func getDocument(id: String, completion: ((Result<NotificationToken?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(id).getDocument { (document, error) in
            
            let result = Result<NotificationToken?, Error> {
                if let error = error {
                    throw error
                }

                guard let document = document, document.exists else {
                    return nil
                }
                
                let dic = document.data(with: .estimate)
                
                guard let dic = dic else {
                    return nil
                }
                
                let token = NotificationToken(id: dic["id"] as! String,
                                              notificationToken: dic["notification_token"] as? String)
                
                return token
            }
            
            completion?(result)
        }
    }
    
    
    func setData(_ data: NotificationToken, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }
}
