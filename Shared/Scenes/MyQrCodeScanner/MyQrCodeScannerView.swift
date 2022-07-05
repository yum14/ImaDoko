//
//  MyQrCodeScannerView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/08.
//

import SwiftUI

struct MyQrCodeScannerView: View {
    @ObservedObject var presenter: MyQrCodeScannerPresenter
    
    var body: some View {
        QrCodeScannerView()
            .found(r: self.presenter.onFoundQrCode)
            .interval(delay: self.presenter.scanInterval)
    }
}

struct MyQrCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = MyQrCodeScannerPresenter(onFound: { _ in })
        MyQrCodeScannerView(presenter: presenter)
    }
}
