//
//  UnreadMessageButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/06/23.
//

import SwiftUI

struct UnreadMessageButton: View {
    var font: Font = .title2
    var badgeFont: Font = .caption
    var badgePadding: CGFloat = 6
    var badgeText: String?
    var width: CGFloat = 54
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            self.onTap?()
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "message")
                    .foregroundColor(Color("IconColor"))
                    .font(self.font)
                    .frame(width: self.width, height: self.width)
                
                if let badgeText = self.badgeText {
                    Text(badgeText)
                        .font(self.badgeFont)
                        .padding(self.badgePadding)
                        .foregroundColor(.white)
                        .background(.red)
                        .clipShape(Circle())
                }
            }
        }
        .background(Color(uiColor: .systemBackground))
    }
}

struct UnreadMessageButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            UnreadMessageButton(badgeText: "100")
                .environment(\.colorScheme, scheme)
        }
    }
}
