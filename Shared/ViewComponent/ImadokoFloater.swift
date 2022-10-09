//
//  ImadokoFloater.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/08/17.
//

import SwiftUI

struct ImadokoFloater: View {
    var radius: CGFloat = 48
    var avatarImages: [UIImage?]
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                ForEach(Array(self.avatarImages.enumerated()), id: \.offset) { offset, image in
                    AvatarCircleImage(image: image, radius: self.radius)
                        .padding(.trailing, CGFloat(offset) * 20)
                }
            }
            .padding(.leading, 8)
            Text("ImadokoReceived")
            Spacer()
        }
        .padding(.vertical, 8)
        .frame(width: 360)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(100)
    }
}

struct ImadokoFloater_Previews: PreviewProvider {
    static var previews: some View {
        return ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                return ImadokoFloater(avatarImages: [nil,nil,nil,nil])
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
            }
        }
    }
}
