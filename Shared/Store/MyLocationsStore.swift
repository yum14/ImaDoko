//
//  MyLocationsStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/17.
//

import Foundation
import Firebase

final class MyLocationsStore {
    private var db: Firestore?
    private let collectionName = "mylocations"
    private var listener: ListenerRegistration?
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func addListener(id: String, overwrite: Bool = true, completion: ((Result<MyLocations?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        if !overwrite && self.listener != nil {
            return
        }
        
        self.listener = self.db!.collection(self.collectionName).document(id)
            .addSnapshotListener { documentSnapshot, error in
                
                let result = Result<MyLocations?, Error> {
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
    
    func setData(_ data: MyLocations, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }
    
    func appendLocation(_ data: Location, id: String, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(id).updateData(["locations": FieldValue.arrayUnion([data.toDictionary()])],
                                                                    completion: completion)
    }
    
    private func map(documentSnapshot: DocumentSnapshot?) -> MyLocations? {
        guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
            return nil
        }
        
        let dic = documentSnapshot.data(with: .estimate)
        
        guard let dic = dic else {
            return nil
        }
        
        let locations = (dic["locations"] as! [[String:Any]])
            .map { Location(id: $0["id"] as! String, latitude: $0["latitude"] as! Double, longitude: $0["longitude"] as! Double) }
        
        let myLocations = MyLocations(id: dic["id"] as! String,
                                      locations: locations)
        
        return myLocations
    }
}
