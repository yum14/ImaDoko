//
//  ImadokoMessagesStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/21.
//

import Foundation
import Firebase

final class ImadokoMessagesStore {
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
    
    func addListener(id: String, overwrite: Bool = true, completion: ((Result<ImadokoMessages?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        if !overwrite && self.listener != nil {
            return
        }
        
        self.listener = self.db!.collection(self.collectionName).document(id)
            .addSnapshotListener { documentSnapshot, error in
                
                let result = Result<ImadokoMessages?, Error> {
                    if let error = error {
                        throw error
                    }
                    
                    return self.map(documentSnapshot: documentSnapshot)
                }
                
                completion?(result)
            }
    }
    
    func removeListener() {
        self.listener?.remove()
        self.listener = nil
    }
    
    func setData(_ data: ImadokoMessages, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }
    
    func appendImadokoMessage(_ data: ImadokoMessage, id: String, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(id).updateData(["messages": FieldValue.arrayUnion([data.toDictionary()])],
                                                                    completion: completion)
    }
    
    private func map(documentSnapshot: DocumentSnapshot?) -> ImadokoMessages? {
        guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
            return nil
        }
        
        let dic = documentSnapshot.data(with: .estimate)
        
        guard let dic = dic else {
            return nil
        }
        
        let data = (dic["messages"] as! [[String:Any]])
            .map { ImadokoMessage(id: $0["id"] as! String, createdAt: ($0["created_at"] as! Timestamp).dateValue(), replyed: $0["replyed"] as! Bool) }
        
        let messages = ImadokoMessages(id: dic["id"] as! String,
                                       messages: data)
        
        return messages
    }
}
