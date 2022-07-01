//
//  PinItem.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/12.
//

import Foundation
import CoreLocation
import SwiftUI

struct PinItem: Identifiable {
    var id: String
    var coordinate: CLLocationCoordinate2D
    var imageData: Data?
    var tint: Color?
    var createdAt: Date
}
