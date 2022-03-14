//
//  AvatarImageStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/12.
//

import Foundation
import Firebase

final class AvatarImageStore {
    private var db: Firestore?
    private let parentCollectionName = "profiles"
    private let collectionName = "avatar_image"
    private let cache = AvatarImageCache.shared
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func getDocument(id: String, noCache: Bool = false, completion: ((Result<AvatarImage?, Error>) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        if !noCache {
            let avatarCache = cache.get(forKey: id)
            if let avatarCache = avatarCache {
                completion?(Result<AvatarImage?, Error> { AvatarImage(id: id, data: avatarCache) })
                return
            }
        }
        
        db!.collection(self.parentCollectionName).document(id)
            .collection(self.collectionName).document(id).getDocument { (documentSnapshot, error) in
                
                let result = Result<AvatarImage?, Error> {
                    if let error = error {
                        throw error
                    }
                    
                    let image = self.map(documentSnapshot: documentSnapshot)
                    
                    self.cache.set(image?.data, forKey: id)
                    return image
                }
                
                
                completion?(result)
            }
    }
    
    private func map(documentSnapshot: DocumentSnapshot?) -> AvatarImage? {
        guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
            return nil
        }
        
        let dic = documentSnapshot.data(with: .estimate)
        
        guard let dic = dic else {
            return nil
        }
        
        let avatarImage = AvatarImage(id: dic["id"] as! String,
                                      data: dic["data"] as! Data)
        
        return avatarImage
    }
    
    
    func setData(_ data: AvatarImage, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.parentCollectionName).document(data.id)
            .collection(self.collectionName).document(data.id).setData(data.toDictionary()) { error in
                
                self.cache.set(data.data, forKey: data.id)
                completion?(error)
            }
    }
    
}
