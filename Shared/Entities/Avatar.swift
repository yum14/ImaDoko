//
//  Avatar.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/15.
//

import Foundation
import SwiftUI

struct Avatar: Identifiable, Hashable {
    var id: String
    var name: String
    var avatarImageData: Data?
    
    func getAvatarImageFromImageData() -> UIImage? {
        guard let data = self.avatarImageData else {
            return nil
        }
        
        return UIImage(data: data)
    }
}
