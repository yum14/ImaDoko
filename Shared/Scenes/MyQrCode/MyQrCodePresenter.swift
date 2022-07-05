//
//  MyQrCodePresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/07.
//

import Foundation
import SwiftUI

final class MyQrCodePresenter: ObservableObject {
    @Published var QrCodeImage: UIImage?
    let qrCodeManager = QrCodeManager()
    
    init(uid: String) {
        DispatchQueue.main.async {
            self.QrCodeImage = self.qrCodeManager.make(uid: uid)
        }
    }
}
