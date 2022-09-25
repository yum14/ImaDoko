//
//  LaunchScreenView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/09/24.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            VStack {
                Image("LaunchScreen")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("MainColor"))
            
            VStack {
                Spacer()
                    .frame(height: 300)
                ActivityIndicator()
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
