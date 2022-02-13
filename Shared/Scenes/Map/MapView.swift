//
//  MapView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var presenter: MapPresenter
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: self.$region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .none,
                annotationItems: self.presenter.pinItems
            ) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    AvatorMapAnnotation()
                        .offset(x: 0, y: -32)
                }
            }
            .ignoresSafeArea(edges: [.trailing, .leading, .top])
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    LocationButton()
                        .cornerRadius(8)
                        .shadow(radius: 5, x: 0, y: 5)
                        .padding()
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let router = MapRouter()
        let presenter = MapPresenter(router: router)
        presenter.pinItems = [PinItem(coordinate: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088))]
        
        return ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            MapView(presenter: presenter)
                .environment(\.colorScheme, scheme)
        }
    }
}
