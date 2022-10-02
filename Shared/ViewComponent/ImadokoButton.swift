//
//  ImadokoButton.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/02.
//

import SwiftUI

struct ImadokoButton: View {
    var onTap: (() -> Void)?
    var disabled: Bool = false
    
    var body: some View {
        Button {
            self.onTap?()
        } label: {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("ImaDokoButton")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
//            .frame(width: 184, height: 40)
            .frame(width: 160, height: 40)
            .background(self.disabled ? Color.gray :  Color("MainColor"))
            .cornerRadius(24)
        }
        .padding(.bottom, 24)
        .disabled(self.disabled)
    }
}

struct ImadokoButton_Previews: PreviewProvider {
    static var previews: some View {
        ImadokoButton()
    }
}
