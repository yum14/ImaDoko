//
//  ImadokoNotificationView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/04.
//

import SwiftUI

struct ImadokoNotificationView: View {
    var userName: String?
    var avatarImage: UIImage?
    var onReply: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    AvatarCircleImage(image: self.avatarImage, radius: 140)
                    Text(self.userName ?? "")
                        .lineLimit(1)
                        .font(.title2)
                }
                .padding()
                
                VStack {
                    Text("ImadokoNotificationDesc1")
                    Text("ImadokoNotificationDesc2")
                }
                
                HStack {
                    Button {
                        self.onReply?()
                    } label: {
                        Text("ImadokoNotificationSend")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(width: 120, height: 40)
                            .background(Color("MainColor"))
                            .cornerRadius(24)
                    }
                    .padding(4)
                    
                    Button {
                        self.onDismiss?()
                    } label: {
                        Text("ImadokoNotificationDismiss")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(width: 120, height: 40)
                            .background(Color("MainColor"))
                            .cornerRadius(24)
                    }
                    .padding(4)
                }
                .padding()
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
    }
}

struct ImadokoNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            ForEach(["ja_JP", "en_US"], id: \.self) { id in
                VStack {
                    ImadokoNotificationView(userName: "userName")
                        .padding()
                        .environment(\.locale, .init(identifier: id))
                        .environment(\.colorScheme, scheme)
                }
                .background(Color.black.opacity(0.3))
            }
        }
    }
}
