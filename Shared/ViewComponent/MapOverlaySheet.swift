//
//  MapOverlaySheet.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/13.
//

import SwiftUI

struct MapOverlaySheet<Content: View>: View {
    
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.secondary)
                .frame(width: 36, height: 5)
                .padding(.top, 6)

            self.content
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.maxX)
        .background(Color(uiColor: UIColor.systemBackground))
        .cornerRadius(12)
    }
}

struct MapOverlaySheet_Previews: PreviewProvider {
    static var previews: some View {
        MapOverlaySheet {
            Text("preview")
        }
    }
}
