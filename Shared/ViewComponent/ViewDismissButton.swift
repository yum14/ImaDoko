//
//  ViewDismissButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/08.
//

import SwiftUI

struct ViewDismissButton: View {
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            self.onTap?()
        } label: {
            Image(systemName: "xmark")
        }
    }
}

struct ViewDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        ViewDismissButton()
    }
}
