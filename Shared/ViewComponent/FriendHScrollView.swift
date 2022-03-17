//
//  FriendHScrollView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/14.
//

import SwiftUI

struct FriendHScrollView: View {
    var friends: [Avatar] = []
    @Binding var selectedIds: [String]
    var radius: CGFloat = 68
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(self.friends, id: \.self) { friend in
                    VStack {
                        ZStack(alignment: .bottom) {
                            let uiImage = friend.avatarImageData != nil ? UIImage(data: friend.avatarImageData!) : nil
                            AvatarCircleImage(image: uiImage, radius: self.radius)

                            if self.selectedIds.contains(friend.id) {
                                HStack {
                                    Spacer()
                                    CheckCircleImage()
                                }
                            }
                        }
                        
                        Text(friend.name)
                            .frame(width: 64, height: 32, alignment: .top)
                            .font(.caption)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 2)
                    .onTapGesture {
                        
                        var newList: [String] = self.selectedIds
                        
                        let index = newList.firstIndex(where: { $0 == friend.id })
                        
                        if let index = index {
                            newList.remove(at: index)
                        } else {
                            newList.append(friend.id)
                        }
                        
                        let newListWithIndex = newList.enumerated().map( { ($0.element, $0.offset) })
                        
                        // friendsの並び順に合わせてソートする
                        self.selectedIds = newListWithIndex.sorted(by: { $0.1 < $1.1 }).map { $0.0 }
                    }
                }
                
            }
        }
    }
}

struct SelectedFriend {
    var id: String
    var selected: Bool
}

struct FriendHScrollView_Previews: PreviewProvider {
    static var previews: some View {
        let friends = [Avatar(id: "a", name: "友だち１aaaaa"),
                       Avatar(id: "b", name: "友だち２"),
                       Avatar(id: "c", name: "友だち３")]
            
        ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            FriendHScrollView(friends: friends, selectedIds: .constant(["a"]))
                .environment(\.colorScheme, scheme)
        }
    }
}
