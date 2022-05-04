//
//  KokodayoButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/02.
//

import SwiftUI
import MapKit

struct KokodayoButton: View {
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            self.onTap?()
        } label: {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.title)
                    .foregroundColor(.white)
                                            
                Text("KokodayoButton")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .frame(width: 184, height: 40)
            .background(Color("MainColor"))
            .cornerRadius(24)
        }
        .padding(.bottom, 24)
    }
}

struct KokodayoButton_Previews: PreviewProvider {
    static var previews: some View {
        KokodayoButton()
    }
}
