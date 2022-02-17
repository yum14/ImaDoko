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
            AvatorCircleImage(image: nil, radius: 36)
            
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
