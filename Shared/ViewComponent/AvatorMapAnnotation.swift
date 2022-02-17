//
//  AvatorMapAnnotation.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/12.
//

import SwiftUI
import MapKit

struct AvatorMapAnnotation: View {
    var image: UIImage?
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                ZStack {
                    Circle()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray)
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 2))
                        
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 48, height: 48)
                            .foregroundColor(.gray)
                            .background(Color(uiColor: .systemBackground))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 2))
                    }
                }
            }
            .padding(.bottom, 6)
            
            Triangle()
                .fill(.red)
                .frame(width: 20, height: 16)
        }
        .shadow(radius: 5, x: 0, y: 5)
    }
}

struct AvatorMapAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            AvatorMapAnnotation()
                .environment(\.colorScheme, scheme)
        }
    }
}
