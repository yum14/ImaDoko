//
//  SendResultFloater.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/05/25.
//

import SwiftUI
import CoreData

struct SendResultFloater: View {
    
    enum ResultType {
        case complete
        case failed
    }
    
    var result: ResultType = .complete
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("NotificationViewColor"))
            
            Text(self.result == .complete ? "SendCompleted" : "SendFailed")
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        .frame(width: 240)
        .frame(height: 40)
    }
}

struct SendResultFloater_Previews: PreviewProvider {
    static var previews: some View {
        return ForEach(["ja_JP", "en_US"], id: \.self) { id in
            ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
                ForEach([SendResultFloater.ResultType.complete, SendResultFloater.ResultType.failed], id: \.self) { resultType in
                    return SendResultFloater(result: resultType)
                        .environment(\.locale, .init(identifier: id))
                        .environment(\.colorScheme, scheme)
                }
            }
        }
    }
}
