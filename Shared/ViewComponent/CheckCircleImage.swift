//
//  CheckCircleImage.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/14.
//

import SwiftUI

struct CheckCircleImage: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 24)
                .foregroundColor(.green)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 2))
        }
    }
}

struct CheckCircleImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CheckCircleImage()
        }
        .background(Color.black)
    }
}
