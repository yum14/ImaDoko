//
//  AvatarCircleImage.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/14.
//

import SwiftUI

struct AvatarCircleImage: View {
    var image: UIImage?
    var radius: CGFloat = 36
    
    var body: some View {
        Group {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .background(Color(uiColor: .systemBackground))
            }
        }
        .frame(width: self.radius, height: self.radius)
        .clipShape(Circle())
    }
}

struct AvatarCircleImage_Previews: PreviewProvider {
    static var previews: some View {
        AvatarCircleImage()
    }
}
