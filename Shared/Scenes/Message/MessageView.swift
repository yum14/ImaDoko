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
            if self.presenter.unrepliedMessages.count > 0 {
                List {
                    Section {
                        ForEach(self.presenter.unrepliedMessages, id: \.self) { message in
                            UnrepliedMessageItem(from: message.fromName,
                                                 createdAt: message.createdAt,
                                                 avatarImage: message.avatarImage,
                                                 onArrowTap: { self.presenter.onSendButtonTap(message: message) },
                                                 onTrashTap: { self.presenter.onTrashButtonTap(message: message) })
                        }
                    } footer: {
                        HStack {
                            Text("NoMessagesSub")
                                .font(.footnote)
                            Spacer()
                        }
                    }
                }
                
            } else {
                VStack {
                    Text("NoMessagesMain")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    
                    Text("NoMessagesSub")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 64)
                }
            }
        }
        .alert(String(format: NSLocalizedString("SendNotificationFromUnrepliedMessage", comment: ""), self.presenter.selectedMessage?.fromName ?? ""), isPresented: self.$presenter.showingSendNotificationAlert) {
            Button("CencelButton", role: .cancel) {}
            Button("NotificationSend") {
                self.presenter.onSendLocationConfirm(myLocation: self.appDelegate.region.center)
            }
        }
        .alert(String(format: NSLocalizedString("DeleteUnrepliedMessage", comment: ""), self.presenter.selectedMessage?.fromName ?? ""), isPresented: self.$presenter.showingDeleteAlert) {
            Button("DeleteButton", role: .destructive) {
                self.presenter.onDeleteMessageConfirm()
            }
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
        presenter.unrepliedMessages = [Message(fromId: "userId1", fromName: "アカウント1"),
                                       Message(fromId: "userId2", fromName: "アカウント2")]
        
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
