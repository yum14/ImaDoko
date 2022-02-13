//
//  MapPresenter.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import Foundation
import MapKit

final class MapPresenter: ObservableObject {
    @Published var pinItems: [PinItem] = [PinItem(coordinate: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088))]
    
    private let router: MapWireframe
    
    init(router: MapWireframe) {
        self.router = router
    }
}
