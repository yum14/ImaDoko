//
//  LocationButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/13.
//

import SwiftUI

struct LocationButton: View {
    var font: Font = .title2
    var width: CGFloat = 54
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            self.onTap?()
        } label: {
            Image(systemName: "location")
                .foregroundColor(Color("IconColor"))
                .font(self.font)
                .frame(width: self.width, height: self.width)
        }
        .background(Color(uiColor: .systemBackground))
    }
}

struct LocationButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            LocationButton()
                .environment(\.colorScheme, scheme)
        }
    }
}
