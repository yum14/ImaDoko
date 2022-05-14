//
//  LocationStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/17.
//

import Foundation
import Firebase

final class LocationStore {
    private var db: Firestore?
    private let collectionName = "locations"
    private var listener: ListenerRegistration?
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func addListener(ownerId: String, overwrite: Bool = true, completion: ((Result<[Location]?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        if !overwrite && self.listener != nil {
            return
        }
        
        self.listener = self.db!.collection(self.collectionName)
            .whereField("ownerId", isEqualTo: ownerId)
            .addSnapshotListener { querySnapshot, error in
                
                let result = Result<[Location]?, Error> {
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
    
    func setData(_ data: Location, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }
    
    private func map(querySnapshot: QuerySnapshot?) -> [Location] {
        guard let querySnapshot = querySnapshot, querySnapshot.documents.count > 0 else {
            return []
        }
        
        let locations = querySnapshot.documents.map { documentSnapshot -> Location in
            let doc = documentSnapshot.data(with: .estimate)
            return Location(id: doc["id"] as! String,
                            userId: doc["userId"] as! String,
                            ownerId: doc["ownerId"] as! String,
                            latitude: doc["latitude"] as! Double,
                            longitude: doc["longitude"] as! Double,
                            createdAt: (doc["created_at"] as! Timestamp).dateValue())
        }
        
        return locations
    }
}
