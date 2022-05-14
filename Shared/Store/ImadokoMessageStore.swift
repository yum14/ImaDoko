//
//  ImadokoMessageStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/21.
//

import Foundation
import Firebase

final class ImadokoMessageStore {
    private var db: Firestore?
    private let collectionName = "imadoko_messages"
    private var listener: ListenerRegistration?
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func addListener(ownerId: String, overwrite: Bool = true, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        if !overwrite && self.listener != nil {
            return
        }
        
        self.listener = self.db!.collection(self.collectionName)
            .whereField("ownerId", isEqualTo: ownerId)
            .addSnapshotListener { querySnapshot, error in
                
                let result = Result<[ImadokoMessage]?, Error> {
                    if let error = error {
                        throw error
                    }
                    
                    return self.map(querySnapshot: querySnapshot)
                }
                
                completion?(result)
            }
    }
    
    func removeListener() {
        self.listener?.remove()
        self.listener = nil
    }
    
    func setData(_ data: ImadokoMessage, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }

    func delete(id: String, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(id).delete(completion: completion)
    }
    
    private func map(querySnapshot: QuerySnapshot?) -> [ImadokoMessage] {
        guard let querySnapshot = querySnapshot, querySnapshot.documents.count > 0 else {
            return []
        }
        
        let messages = querySnapshot.documents.map { documentSnapshot -> ImadokoMessage in
            let doc = documentSnapshot.data(with: .estimate)
            return ImadokoMessage(id: doc["id"] as! String,
                                  userId: doc["userId"] as! String,
                                  ownerId: doc["ownerId"] as! String,
                                  replyed: doc["replyed"] as! Bool,
                                  createdAt: (doc["created_at"] as! Timestamp).dateValue())
        }
        
        return messages
    }
}
