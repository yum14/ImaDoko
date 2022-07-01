//
//  SendMessageButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/01.
//

import SwiftUI

struct SendMessageButton: View {
    var onTap: (() -> Void)?
    var disabled: Bool = false
    
    var body: some View {
        Button {
            self.onTap?()
        } label: {
            Text("MapOverlaySheetButton")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(width: 320, height: 40)
                .background(self.disabled ? Color.gray :  Color("MainColor"))
                .cornerRadius(16)
        }
        .disabled(self.disabled)
    }
}

struct SendMessageButton_Previews: PreviewProvider {
    static var previews: some View {
        SendMessageButton()
    }
}
