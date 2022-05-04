//
//  PinDetailView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/04/23.
//

import SwiftUI

struct PinDetailView: View {
    @ObservedObject var presenter: PinDetailPresenter
    @EnvironmentObject var appDelegate: AppDelegate
    
    var body: some View {
        VStack {
            Spacer()

            AvatarCircleImage(image: self.presenter.friend.getAvatarImageFromImageData(), radius: 80)
            Text(self.presenter.friend.name)
                .font(.title3)
                .lineLimit(1)
                .frame(width: 240)
                .padding(.bottom, 1)
            
            Text(DateUtility.toString(date: self.presenter.createdAt, template: "ydMMM HH:mm:ss"))
                .font(.caption)
            
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()

                ImadokoButton(onTap: self.presenter.onImadokoButtonTap)

                Spacer()
                
                KokodayoButton(onTap: {
                    self.presenter.onKokodayoButtonTap(myLocation: self.appDelegate.region.center)
                })
                
//                Spacer()
            }
        }
    }
}

struct PinDetailView_Previews: PreviewProvider {
    static let appDelegate = AppDelegate()
    
    static var previews: some View {
        let interactor = PinDetailInteractor()
        let router = PinDetailRouter()
        let presenter = PinDetailPresenter(interactor: interactor, router: router, myId: "myId", myName: "myName", friend: Avatar(id: "friendId", name: "friendName"), createdAt: Date.now, onDismiss: {})
        PinDetailView(presenter: presenter)
            .environmentObject(appDelegate)
    }
}
