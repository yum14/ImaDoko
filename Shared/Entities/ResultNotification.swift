//
//  ResultNotification.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/26.
//

import Foundation

final class ResultNotification: ObservableObject {
    @Published var showing = false
    var text = ""
    
    func show(text: String) {
        self.text = text
        self.showing = true
    }
    
    func hide() {
        self.showing = false
    }
}
