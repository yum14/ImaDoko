//
//  FriendListItem.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/12.
//

import SwiftUI

struct FriendListItem: View {
    var name: String
    var avatorImage: Data? = nil
    
    var body: some View {
        HStack {
            Group {
                if let avatorImage = avatorImage, let uiImage = UIImage(data: avatorImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .background(Color(uiColor: .systemBackground))
                }
            }
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            
            Text(self.name)
                .frame(height: 36)
            
            Spacer()
        }
        .background(Color(uiColor: .systemBackground))
    }
}

struct FriendListItem_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            FriendListItem(name: "友だち１")
                .environment(\.colorScheme, scheme)
        }
    }
}
