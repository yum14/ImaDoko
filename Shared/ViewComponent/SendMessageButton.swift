//
//  SendMessageButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/01.
//

import SwiftUI

struct SendMessageButton: View {
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            self.onTap?()
        } label: {
            Text("MapOverlaySheetButton")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(width: 320, height: 40)
                .background(Color("MainColor"))
                .cornerRadius(16)
        }
    }
}

struct SendMessageButton_Previews: PreviewProvider {
    static var previews: some View {
        SendMessageButton()
    }
}
