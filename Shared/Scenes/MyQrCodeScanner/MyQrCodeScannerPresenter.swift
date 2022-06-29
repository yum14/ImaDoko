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
    
    init(onFound: ((String) -> Void)?) {
        self.onFound = onFound
    }
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
        self.onFound?(code)
    }
}
