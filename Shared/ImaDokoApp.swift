//
//  ImaDokoApp.swift
//  Shared
//
//  Created by yum on 2022/02/06.
//

import SwiftUI

@main
struct ImaDokoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let authentication = Authentication()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authentication)
        }
    }
}
