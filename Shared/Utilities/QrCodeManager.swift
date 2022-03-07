//
//  QrCodeManager.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/07.
//

import Foundation
import SwiftUI

class QrCodeManager {
    private let schema = "https://"
    private let domain = "icu.yum14/"
    private let path = "ImaDoko/friends/"
    
    func make(uid: String) -> UIImage? {
        if uid.isEmpty {
            return nil
        }
        
        let url = URL(string: self.schema + self.domain + self.path + uid)
        
        guard let data = url?.absoluteString.data(using: .utf8) else {
            return nil
        }

        // 誤り訂正レベルはとりあえずQを指定
        guard let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "Q"]) else {
            return nil
        }

        // 元のCIImageは小さいので任意のサイズに拡大
        let sizeTransform = CGAffineTransform(scaleX: 8, y: 8)

        guard let ciImage = qr.outputImage?.transformed(by: sizeTransform) else {
            return nil
        }

        // CIImageをそのまま変換するとImageで表示されないため一度CGImageに変換してからUIImageに変換する
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }

        let image = UIImage(cgImage: cgImage)

        return image
    }
    
    func checkMyAppQrCode(code: String) -> String? {
        if code.isEmpty {
            return nil
        }
        
        guard let url = URL(string: code), let _ = url.scheme, let _ = url.host else {
            return nil
        }
        
        if !(url.pathComponents[0] == "/" && url.pathComponents[1] == "ImaDoko" && url.pathComponents[2] == "friends") {
            return nil
        }
        
        return url.lastPathComponent
    }
}
