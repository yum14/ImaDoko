//
//  LocationButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/13.
//

import SwiftUI

struct LocationButton: View {
    var font: Font = .title2
    var padding: CGFloat = 12
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            self.onTap?()
        } label: {
            Image(systemName: "location")
                .foregroundColor(Color("IconColor"))
                .font(self.font)
                .padding(self.padding)
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
