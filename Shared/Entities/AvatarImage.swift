//
//  AvatarImage.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/12.
//

import Foundation
import Firebase

struct AvatarImage: Identifiable, Hashable {
    var id: String
    var data: Data

    init(id: String = UUID().uuidString,
         data: Data) {
        
        self.id = id
        self.data = data
    }
    
    func toDictionary() -> [String: Any] {
        var dic: [String: Any] = [:]
        dic["id"] = self.id
        dic["data"] = self.data
        
        return dic
    }
}
