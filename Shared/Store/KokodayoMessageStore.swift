//
//  KokodayoMessageStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/07/17.
//

import Foundation
import Firebase

final class KokodayoMessageStore {
    private var db: Firestore?
    private let collectionName = "kokodayo_messages"
    private var listener: ListenerRegistration?
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func addListenerForAdditionalData(toId: String, isGreaterThan: Date, overwrite: Bool = true, completion: ((Result<[KokodayoMessage], Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        if !overwrite && self.listener != nil {
            return
        }
        
        self.removeListener()
        
        self.listener = self.db!.collection(self.collectionName)
            .whereField("to_id", isEqualTo: toId)
            .whereField("is_read", isEqualTo: false)
            .whereField("created_at", isGreaterThan: isGreaterThan)
            .addSnapshotListener { querySnapshot, error in
                
                guard let querySnapshot = querySnapshot, querySnapshot.documents.count > 0 else {
                    return
                }
                
                if let error = error {
                    completion?(Result<[KokodayoMessage], Error> { throw error })
                    return
                }
                
                
                let messages: [KokodayoMessage] = querySnapshot.documentChanges.compactMap { documentChange in
                    if documentChange.type != .added {
                        return nil
                    }
                    return self.map(documentSnapshot: documentChange.document)
                }
                
                if messages.count > 0 {
                    completion?(Result<[KokodayoMessage], Error> { messages })
                }
            }
    }
    
    func removeListener() {
        self.listener?.remove()
        self.listener = nil
    }
    
    func setData(_ data: KokodayoMessage, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }

    func batchUpdateToAlreadyRead(ids: [String], completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        let batch = db!.batch()
        
        
        for id in ids {
            let nycRef = db!.collection(self.collectionName).document(id)
            batch.updateData(["is_read": true], forDocument: nycRef)
        }
        
        batch.commit(completion: completion)
    }
    
    private func map(documentSnapshot: DocumentSnapshot) -> KokodayoMessage? {
        guard let doc = documentSnapshot.data(with: .estimate) else {
            return nil
        }
        
        return KokodayoMessage(id: doc["id"] as! String,
                              fromId: doc["from_id"] as! String,
                              toId: doc["to_id"] as! String,
                              latitude: doc["latitude"] as! Double,
                              longitude: doc["longitude"] as! Double,
                              isRead: doc["is_read"] as! Bool,
                              createdAt: (doc["created_at"] as! Timestamp).dateValue())
    }
}
