//
//  MessageView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var presenter: MessagePresenter
    @EnvironmentObject var appDelegate: AppDelegate
    
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
                        UnrepliedMessageItem(from: message.userName,
                                             createdAt: message.createdAt,
                                             avatarImage: message.avatarImage,
                                             onArrowTap: { self.presenter.onSendButtonTap(message: message) },
                                             onTrashTap: { self.presenter.onTrashButtonTap(message: message) })
                    }
                }
            }
        }
        
        .alert(String(format: NSLocalizedString("SendNotificationFromUnrepliedMessage", comment: ""), self.presenter.selectedMessage?.userName ?? ""), isPresented: self.$presenter.showingSendNotificationAlert) {
            Button("CencelButton", role: .cancel) {
                print("cancel")
            }
            Button("NotificationSend") {
                self.presenter.onSendLocationConfirm(myLocation: self.appDelegate.region.center)
            }
        }
        .alert(String(format: NSLocalizedString("DeleteUnrepliedMessage", comment: ""), self.presenter.selectedMessage?.userName ?? ""), isPresented: self.$presenter.showingDeleteAlert) {
            Button("DeleteButton", role: .destructive) {
                self.presenter.onDeleteMessageConfirm()
            }
        }
        .onAppear {
            self.presenter.onAppear()
        }
        .onDisappear {
            self.presenter.onDisappear()
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static let appDelegate = AppDelegate()
    
    static var previews: some View {
        let interactor = MessageInteractor()
        let router = MessageRouter()
        let presenter = MessagePresenter(interactor: interactor, router: router, uid: "uid")
        presenter.unreadMessages = [Message(userId: "userId1", userName: "アカウント1"),
                                    Message(userId: "userId2", userName: "アカウント2")]
        
        return ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                MessageView(presenter: presenter)
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
                    .environmentObject(appDelegate)
            }
        }
    }
}
