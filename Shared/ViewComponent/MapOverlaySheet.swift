//
//  MapOverlaySheet.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/13.
//

import SwiftUI

struct MapOverlaySheet: View {
    
    var friends: [Profile] = []
    var avatarImages: [String:Data] = [:]
    @Binding var editable: Bool
    var onSendMessageButtonTap: (() -> Void)?
    let bounds = UIScreen.main.bounds
    
    @State private var selectedFriends: [String] = []
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.secondary)
                .frame(width: 36, height: 5)
                .padding(.top, 4)
            
            if self.editable {
                
                Text("SelectDestinationHeader")
                    .fontWeight(.bold)
                    .frame(width: 320, height: 32)
                
                
                FriendScrollView(friends: self.friends, avatarImages: self.avatarImages, selectedList: self.$selectedFriends)
                    .padding()
                
                HStack(spacing: 0) {
                    Spacer()
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.questionmark")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Text("ImaDokoButton")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .frame(width: 184, height: 40)
                        .background(Color("MainColor"))
                        .cornerRadius(24)
                    }
                    .padding(.bottom, 24)

                    Spacer()
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .font(.title)
                                .foregroundColor(.white)
                                                        
                            Text("ImaKokoButton")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .frame(width: 184, height: 40)
                        .background(Color("MainColor"))
                        .cornerRadius(24)
                    }
                    .padding(.bottom, 24)
                    
                    Spacer()
                }
                
            } else {
                Button {
                    self.onSendMessageButtonTap?()
                } label: {
                    Text("MapOverlaySheetButton")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(width: 320, height: 40)
                        .background(Color("MainColor"))
                        .cornerRadius(16)
                }
            }
            
            Spacer()
            
        }
        .frame(width: self.bounds.maxX)
        .background(Color(uiColor: UIColor.systemBackground))
    }
}

struct MapOverlaySheet_Previews: PreviewProvider {
    static var previews: some View {
        let friends = [Profile(name: "友だち１"),
                       Profile(name: "友だち２"),
                       Profile(name: "友だち３"),
                       Profile(name: "友だち４"),
                       Profile(name: "友だち５"),
                       Profile(name: "友だち６")]
        
        ForEach([true, false], id: \.self) { editable in
            ForEach(["ja_JP", "en_US"], id: \.self) { id in
                ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                    MapOverlaySheet(friends: friends, editable: .constant(editable))
                        .environment(\.locale, .init(identifier: id))
                        .environment(\.colorScheme, scheme)
                }
            }
        }
    }
}
