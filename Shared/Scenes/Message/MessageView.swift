//
//  MessageView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var presenter: MessagePresenter
    
    var body: some View {
        VStack(spacing: 0) {
            Picker(selection: self.$presenter.messageTypeSelection) {
                Text("UnreadMessageHeader").tag(0)
            } label: {
                Text("")
            }
            .pickerStyle(.segmented)
            .padding()
            
            if self.presenter.messageTypeSelection == 0 {
                List {
                    ForEach(self.presenter.unreadMessages, id: \.self) { message in
                        UnrepliedMessageItem(from: message.from,
                                             createdAt: message.createdAt,
                                             avatarImage: message.avatarImage)
                    }
                }
            }
        }
        .onAppear {
            self.presenter.onAppear()
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = MessageInteractor()
        let router = MessageRouter()
        let presenter = MessagePresenter(interactor: interactor, router: router, uid: "")
        presenter.unreadMessages = [Message(from: "アカウント1"),
                                    Message(from: "アカウント2")]
        
        return ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                MessageView(presenter: presenter)
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
            }
        }
    }
}
