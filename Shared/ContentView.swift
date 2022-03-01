//
//  ContentView.swift
//  Shared
//
//  Created by yum on 2022/02/06.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var presenter = RootPresenter(interactor: RootInteractor(), router: RootRouter())
    
    var body: some View {
        RootView(presenter: presenter)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
