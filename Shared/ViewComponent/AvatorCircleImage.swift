//
//  AvatorCircleImage.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/14.
//

import SwiftUI

struct AvatorCircleImage: View {
    var image: Data?
    var radius: CGFloat = 36
    
    var body: some View {
        Group {
            if let image = image, let uiImage = UIImage(data: image) {
                Image(uiImage: uiImage)
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

struct AvatorCircleImage_Previews: PreviewProvider {
    static var previews: some View {
        AvatorCircleImage()
    }
}
