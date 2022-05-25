//
//  MessageDestinationView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/26.
//

import SwiftUI

struct MessageDestinationView: View {
    @ObservedObject var presenter: MessageDestinationPresenter
    @EnvironmentObject var appDelegate: AppDelegate
    
    var body: some View {
        VStack {
            Text("SelectDestinationHeader")
                .fontWeight(.bold)
                .frame(width: 320, height: 32)
            
            FriendHScrollView(friends: self.presenter.friends,
                              selectedIds: self.$presenter.selectedIds)
                .padding()
            
            HStack(spacing: 0) {
                Spacer()
                ImadokoButton(onTap: self.presenter.onImadokoButtonTap)

                Spacer()
                
                KokodayoButton(onTap: {
                    self.presenter.onKokodayoButtonTap(myLocation: self.appDelegate.region.center)
                })
                
                Spacer()
            }
        }
    }
}

struct MessageDestinationView_Previews: PreviewProvider {
    static let appDelegate = AppDelegate()

    static var previews: some View {
        let friends = [Avatar(id: "1", name: "友だち１"),
                       Avatar(id: "2", name: "友だち２"),
                       Avatar(id: "3", name: "友だち３"),
                       Avatar(id: "4", name: "友だち４"),
                       Avatar(id: "5", name: "友だち５"),
                       Avatar(id: "6", name: "友だち６")]
        
        let interactor = MessageDestinationInteractor()
        let router = MessageDestinationRouter()
        let presenter = MessageDestinationPresenter(interactor: interactor, router: router, myId: "preview_id", myName: "preview_name", friends: friends, onDismiss: {}, onSend: { _ in })
        MessageDestinationView(presenter: presenter)
            .environmentObject(appDelegate)
    }
}
