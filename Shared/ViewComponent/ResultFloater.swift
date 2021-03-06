//
//  ResultFloater.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/25.
//

import SwiftUI
import CoreData

struct ResultFloater: View {
    var text: String
    
    var body: some View {
        VStack {
            Text(self.text)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .lineLimit(nil)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
                
        }
        .background(Color("MainColor"))
        .cornerRadius(100)
    }
}

struct ResultFloater_Previews: PreviewProvider {
    static var previews: some View {
        return ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                return ResultFloater(text: "送信成功")
                    .environment(\.locale, .init(identifier: id))
                    .environment(\.colorScheme, scheme)
            }
        }
    }
}
