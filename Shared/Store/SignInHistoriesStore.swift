//
//  SignInHistoriesStore.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/11/11.
//

import Foundation
import Firebase

final class SignInHistoriesStore {
    private var db: Firestore?
    private let collectionName = "sign_in_histories"
    
    init() {}
    
    private func initialize() {
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        self.db = db
    }
    
    func setData(_ data: SignInHistory, completion: ((Error?) -> Void)?) {
        if self.db == nil {
            self.initialize()
        }
        
        db!.collection(self.collectionName).document(data.id).setData(data.toDictionary(), completion: completion)
    }
}
