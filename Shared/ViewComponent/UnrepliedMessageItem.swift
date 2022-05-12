//
//  UnrepliedMessageItem.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI

struct UnrepliedMessageItem: View {
    var from: String
    var createdAt: Date
    var avatarImage: Data?
    var onArrowTap: (() -> Void)?
    var onTrashTap: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Group {
                    if let avatarImage = avatarImage, let uiImage = UIImage(data: avatarImage) {
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
                
                VStack(alignment: .leading) {
                    Text(self.from)
                    Text(DateUtility.toString(date: self.createdAt, template: "ydMMM HH:mm:ss"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(height: 36)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title)
                    .foregroundColor(Color("MainColor"))
                    .onTapGesture {
                        self.onArrowTap?()
                    }
                
                Image(systemName: "trash.circle.fill")
                    .font(.title)
                    .foregroundColor(Color("MainColor"))
                    .onTapGesture {
                        self.onTrashTap?()
                    }
            }
        }
    }
}

struct UnrepliedMessageItem_Previews: PreviewProvider {
    static var previews: some View {
        UnrepliedMessageItem(from: "アカウント名", createdAt: .now)
            .frame(width: 200)
    }
}
