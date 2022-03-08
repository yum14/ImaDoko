//
//  MyQrCodeScannerPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/08.
//

import Foundation

final class MyQrCodeScannerPresenter: ObservableObject {
    @Published var lastQrCode: String = ""
    
    let scanInterval: Double = 1.0
    var onFound: ((String) -> Void)?
    var onDismiss: (() -> Void)?
    
    init(onFound: ((String) -> Void)?, onDismiss: (() -> Void)?) {
        self.onFound = onFound
        self.onDismiss = onDismiss
    }
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
        self.onFound?(code)
    }
}
