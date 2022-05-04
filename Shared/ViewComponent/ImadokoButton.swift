//
//  ImadokoButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/02.
//

import SwiftUI

struct ImadokoButton: View {
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            self.onTap?()
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
    }
}

struct ImadokoButton_Previews: PreviewProvider {
    static var previews: some View {
        ImadokoButton()
    }
}
