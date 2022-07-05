//
//  MyQrCodeView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/07.
//

import SwiftUI

struct MyQrCodeView: View {
    @ObservedObject var presenter: MyQrCodePresenter
    
    var body: some View {
        VStack {
            Group {
                if let QrCode = self.presenter.QrCodeImage {
                    Image(uiImage: QrCode)
                } else {
                    Text("QRCodeLoading")
                        .frame(height: 248)
                }
            }
            
            HStack {
                Text("QRCodeDescription")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
            }
        }
    }
}

struct MyQrCodeView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = MyQrCodePresenter(uid: "uid")
        MyQrCodeView(presenter: presenter)
    }
}
