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
    
    func addListenerForAdditionalData(ownerId: String, isGreaterThan: Date, overwrite: Bool = true, completion: ((Result<[Location]?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        if !overwrite && self.listener != nil {
            return
        }
        
        self.removeListener()
        
        self.listener = self.db!.collection(self.collectionName)
            .whereField("owner_id", isEqualTo: ownerId)
            .whereField("created_at", isGreaterThan: isGreaterThan)
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
    
    func batchInsert(_ locations: [Location], completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        let batch = db!.batch()
        
        for location in locations {
            let nycRef = db!.collection(self.collectionName).document(location.id)
            batch.setData(location.toDictionary(), forDocument: nycRef)
        }
        
        batch.commit(completion: completion)
    }
    
    func delete(id: String, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(id).delete(completion: completion)
    }
    
    func getDocuments(ownerId: String, userId: String, completion: ((Result<[Location]?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName)
            .whereField("owner_id", isEqualTo: ownerId)
            .whereField("user_id", isEqualTo: userId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion?(Result.failure(error))
                    return
                }
                
                let locations = self.map(querySnapshot: querySnapshot)
                
                completion?(Result.success(locations))
            }
    }
    
    func getDocuments(ownerId: String, isLessThan: Date, completion: ((Result<[Location]?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName)
            .whereField("owner_id", isEqualTo: ownerId)
            .whereField("created_at", isLessThan: isLessThan)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion?(Result.failure(error))
                    return
                }
                
                let locations = self.map(querySnapshot: querySnapshot)
                
                completion?(Result.success(locations))
            }
    }
    
    private func map(querySnapshot: QuerySnapshot?) -> [Location] {
        guard let querySnapshot = querySnapshot, querySnapshot.documents.count > 0 else {
            return []
        }
        
        let locations = querySnapshot.documents.map { documentSnapshot -> Location in
            let doc = documentSnapshot.data(with: .estimate)
            return Location(id: doc["id"] as! String,
                            userId: doc["user_id"] as! String,
                            ownerId: doc["owner_id"] as! String,
                            latitude: doc["latitude"] as! Double,
                            longitude: doc["longitude"] as! Double,
                            createdAt: (doc["created_at"] as! Timestamp).dateValue())
        }
        
        return locations
    }
}
