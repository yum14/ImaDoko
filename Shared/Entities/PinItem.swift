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
    var id = UUID().uuidString
    var coordinate: CLLocationCoordinate2D
    var tint: Color?
}
