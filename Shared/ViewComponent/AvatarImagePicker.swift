//
//  AvatarImagePicker.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/03/08.
//

import SwiftUI

struct AvatarImagePicker: View {
    @Binding var selectedImage: UIImage?
    var radius: CGFloat = 120
    
    @State private var showingImagePicker = false
    private let magnification: Double = 0.75
    
    var body: some View {
        ZStack {
            AvatarCircleImage(image: self.selectedImage, radius: self.radius)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: self.radius * 0.3, height: self.radius * 0.3)
                        .foregroundColor(Color("MainColor"))
                        .background(Color(UIColor.systemBackground))
                        .clipShape(Circle())
                }
            }
            .frame(width: self.radius, height: self.radius)
        }
        .onTapGesture {
            self.showingImagePicker = true
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerController(sourceType: .photoLibrary) { uiImage in
                
                let originScale = uiImage.size.width > uiImage.size.height ? uiImage.size.height / self.radius : uiImage.size.width / self.radius
                let scale = originScale * self.magnification
                
                let xOffset = (uiImage.size.width - self.radius * scale) / 2
                let yOffset = (uiImage.size.height - self.radius * scale) / 2
                
                if let cgImage = uiImage.cgImage {
                    let clipRect = CGRect(x: xOffset, y: yOffset, width: self.radius * scale, height: self.radius * scale)
                    let crippedImage = UIImage(cgImage: cgImage.cropping(to: clipRect)!)
                    self.selectedImage = crippedImage
                }
            }
        }
    }
}

struct AvatarImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        AvatarImagePicker(selectedImage: .constant(nil))
    }
}
