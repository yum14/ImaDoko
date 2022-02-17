//
//  MapPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import SwiftUI
import MapKit
import DynamicOverlay

final class MapPresenter: ObservableObject {
    @Published var pinItems: [PinItem] = [PinItem(coordinate: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088))]
    @Published var notch: Notch = .min {
        didSet {
            self.editable = (self.notch == .max)
        }
    }
    @Published var editable = false
    
    private let router: MapWireframe
    
    init(router: MapWireframe) {
        self.router = router
    }
    
}

enum Notch: CaseIterable, Equatable {
    case min, max
}
