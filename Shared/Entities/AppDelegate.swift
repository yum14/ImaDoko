//
//  AppDelegate.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/27.
//

import Foundation
import SwiftUI

final class AppDelegate: UIResponder, ObservableObject {
    @Published var notificationToken: String?
    
    func setNotificationToken(_ newToken: String?) {
        self.notificationToken = newToken
    }
}
