//
//  SignInHistory.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/11/11.
//

import Foundation
import Firebase

struct SignInHistory: Identifiable, Hashable {
    var id: String
    var lastSignInAt: Timestamp?

    init(id: String = UUID().uuidString) {        
        self.id = id
        self.lastSignInAt = Timestamp(date: Date())
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["last_sign_in_at"] = self.lastSignInAt
        return dic
    }
}
