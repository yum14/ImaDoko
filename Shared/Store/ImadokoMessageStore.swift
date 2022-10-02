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
    private var listenerOnNotReplyed: ListenerRegistration?
    private var listenerOnNotReplyedAndUnRead: ListenerRegistration?
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func addListenerOnNotReplyed(toId: String, isGreaterThan: Date, overwrite: Bool = true, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        if !overwrite && self.listenerOnNotReplyed != nil {
            return
        }
        
        self.removeListenerOnNotReplyed()
        
        self.listenerOnNotReplyed = self.db!.collection(self.collectionName)
            .whereField("to_id", isEqualTo: toId)
            .whereField("replyed", isEqualTo: false)
            .whereField("created_at", isGreaterThan: isGreaterThan)
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
    
    func addListenerOnNotReplyedAndUnRead(toId: String, isGreaterThan: Date, overwrite: Bool = true, completion: ((Result<[ImadokoMessage]?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        if !overwrite && self.listenerOnNotReplyedAndUnRead != nil {
            return
        }
        
        self.removeListenerOnNotReplyedAndUnRead()
        
        self.listenerOnNotReplyedAndUnRead = self.db!.collection(self.collectionName)
            .whereField("to_id", isEqualTo: toId)
            .whereField("replyed", isEqualTo: false)
            .whereField("is_read", isEqualTo: false)
            .whereField("created_at", isGreaterThan: isGreaterThan)
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
    
    func removeListenerOnNotReplyed() {
        self.listenerOnNotReplyed?.remove()
        self.listenerOnNotReplyed = nil
    }
    
    func removeListenerOnNotReplyedAndUnRead() {
        self.listenerOnNotReplyedAndUnRead?.remove()
        self.listenerOnNotReplyedAndUnRead = nil
    }
    
    func setData(_ data: ImadokoMessage, completion: ((Error?) -> Void)?) {
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

    func batchUpdateToReplyed(ids: [String], completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        let batch = db!.batch()
        
        for id in ids {
            let nycRef = db!.collection(self.collectionName).document(id)
            batch.updateData(["replyed": true], forDocument: nycRef)
        }
        
        batch.commit(completion: completion)
    }
    
    private func map(querySnapshot: QuerySnapshot?) -> [ImadokoMessage] {
        guard let querySnapshot = querySnapshot, querySnapshot.documents.count > 0 else {
            return []
        }
        
        let messages = querySnapshot.documents.map { documentSnapshot -> ImadokoMessage in
            let doc = documentSnapshot.data(with: .estimate)
            return ImadokoMessage(id: doc["id"] as! String,
                                  fromId: doc["from_id"] as! String,
                                  toId: doc["to_id"] as! String,
                                  replyed: doc["replyed"] as! Bool,
                                  createdAt: (doc["created_at"] as! Timestamp).dateValue())
        }
        
        return messages
    }
}
