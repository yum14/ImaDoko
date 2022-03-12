//
//  ProfileStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/26.
//

import Foundation
import Firebase

final class ProfileStore {
    private var db: Firestore?
    private let collectionName = "profiles"
    private var listener: ListenerRegistration?
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func addListener(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        self.listener = self.db!.collection(self.collectionName).document(id)
            .addSnapshotListener { documentSnapshot, error in
                
                let result = Result<Profile?, Error> {
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
    }
    
    func getDocument(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(id).getDocument { (documentSnapshot, error) in
            
            let result = Result<Profile?, Error> {
                if let error = error {
                    throw error
                }
                
                return self.map(documentSnapshot: documentSnapshot)
            }
            
            completion?(result)
        }
    }
    
    func getDocuments(ids: [String], completion: ((Result<[Profile]?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).whereField("id", in: ids).getDocuments { querySnapshot, error in
            if let error = error {
                completion?(Result.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion?(Result.success(nil))
                return
            }

            var profiles: [Profile] = []
            
            for document in documents {
                let data = self.map(documentSnapshot: document)
                
                if let data = data {
                    profiles.append(data)
                }
            }
            
            completion?(Result.success(profiles))
        }

    }
    
    private func map(documentSnapshot: DocumentSnapshot?) -> Profile? {
        guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
            return nil
        }
        
        let dic = documentSnapshot.data(with: .estimate)
        
        guard let dic = dic else {
            return nil
        }
        
        let profile = Profile(id: dic["id"] as! String,
                              name: dic["name"] as! String,
                              friends: dic["friends"] as! [String],
                              createdAt: dic["created_at"] as? Timestamp ?? nil,
                              updatedAt: dic["updated_at"] as? Timestamp ?? nil)
        
        return profile
    }
    
    
    func setData(_ data: Profile, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }
    
    func updateName(id: String, name: String, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(id).updateData(["name": name], completion: completion)
    }
    
    func updateFriends(id: String, friends: [String], completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(id).updateData(["friends": friends], completion: completion)
    }
}
