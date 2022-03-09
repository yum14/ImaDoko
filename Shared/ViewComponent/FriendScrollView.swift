//
//  FriendScrollView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/14.
//

import SwiftUI

struct FriendScrollView: View {
    var friends: [Profile] = []
    @Binding var selectedList: [String]
    var radius: CGFloat = 68
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(self.friends, id: \.self) { friend in
                    VStack {
                        ZStack(alignment: .bottom) {
                            let uiImage = friend.avatarImage != nil ? UIImage(data: friend.avatarImage!) : nil
                            AvatarCircleImage(image: uiImage, radius: self.radius)
                            
                            if self.selectedList.contains(friend.id) {
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
                        
                        var newList: [String] = self.selectedList
                        
                        let index = newList.firstIndex(where: { $0 == friend.id })
                        
                        if let index = index {
                            newList.remove(at: index)
                        } else {
                            newList.append(friend.id)
                        }
                        
                        let newListWithIndex = newList.enumerated().map( { ($0.element, $0.offset) })
                        
                        // friendsの並び順に合わせてソートする
                        self.selectedList = newListWithIndex.sorted(by: { $0.1 < $1.1 }).map { $0.0 }
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


struct FriendScrollView_Previews: PreviewProvider {
    static var previews: some View {
        let friends = [Profile(name: "友だち１aaaaa"),
                       Profile(name: "友だち２あ"),
                       Profile(name: "友だち３"),
                       Profile(name: "友だち４"),
                       Profile(name: "友だち５"),
                       Profile(name: "友だち６")]
        
        ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            FriendScrollView(friends: friends, selectedList: .constant([]))
                .environment(\.colorScheme, scheme)
        }
    }
}
