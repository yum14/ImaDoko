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
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func getDocument(id: String, completion: ((Result<Profile?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(id).getDocument { (document, error) in
            
            let result = Result<Profile?, Error> {
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
                
                let profile = Profile(id: dic["id"] as! String,
                                      name: dic["name"] as! String,
                                      avatorImage: dic["avator_image"] as? Data ?? nil,
                                      createdAt: dic["created_at"] as? Timestamp ?? nil,
                                      updatedAt: dic["updated_at"] as? Timestamp ?? nil)
                
                return profile
            }
            
            completion?(result)
        }
    }
    
    
    func setData(_ data: Profile, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }
}
