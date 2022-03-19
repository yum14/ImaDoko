//
//  MapView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI
import MapKit
import DynamicOverlay

//enum Notch: CaseIterable, Equatable {
//    case min, max
//}


struct MapView: View {
    @ObservedObject var presenter: MapPresenter
    @EnvironmentObject var appDelegate: AppDelegate
    
//    @State var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088),
//        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
//    var friends: [Profile] = [Profile(name: "友だち１１１"),
//                              Profile(name: "友だち２"),
//                              Profile(name: "友だち３"),
//                              Profile(name: "友だち４"),
//                              Profile(name: "友だち５")]
    
    //    var myOverlayContent: some View {
    //        VStack {
    //            RoundedRectangle(cornerRadius: 20)
    //                .fill(.secondary)
    //                .frame(width: 36, height: 5)
    //                .padding(.top, 4)
    //            Text("Header")
    //            List {
    //                Text("Row 1")
    //                Text("Row 2")
    //                Text("Row 3")
    //            }
    //        }
    //        .background(Color(uiColor: UIColor.systemBackground))
    //        .drivingScrollView()
    //    }
    
    
//    @State var height: CGFloat = 0.0
//    @State var notch: Notch = .min
    
    var myOverlayBehavior: some DynamicOverlayBehavior {
        MagneticNotchOverlayBehavior<Notch> { notch in
            switch notch {
            case .max:
                return .fractional(0.35)
            case .min:
                return .fractional(0.1)
            }
        }
        .onTranslation { translation in
//            height = translation.height
            print(translation.height)
        }
        .notchChange(self.$presenter.notch)
        .disable(.max, self.presenter.notch == .min)
    }
    
    
    var body: some View {
        ZStack {
            ZStack {
                Map(coordinateRegion: self.$appDelegate.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: .none,
                    annotationItems: self.presenter.pinItems
                ) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        AvatarMapAnnotation(image: item.imageData != nil ? UIImage(data: item.imageData!) : nil)
                            .offset(x: 0, y: -32)
                    }
                }
                .ignoresSafeArea(edges: [.trailing, .leading, .top])
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    LocationButton(onTap: {
                        
                    })
                        .cornerRadius(8)
                        .shadow(radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                        .padding(.bottom, 90)
                }
            }
        }
        .dynamicOverlay(
            MapOverlaySheet(friends: self.presenter.friends,
                            editable: self.$presenter.editable,
                            selectedIds: self.$presenter.selectedFriendIds,
                            onSendMessageButtonTap: {
                                withAnimation {
                                    self.presenter.notch = .max
                                }},
                            onImakokoButtonTap: { self.presenter.onImakokoButtonTap(location: self.appDelegate.region.center) },
                            onImadokoButtonTap: self.presenter.onImadokoButtonTap))
        .dynamicOverlayBehavior(myOverlayBehavior)
        .ignoresSafeArea(edges: [.top, .trailing, .leading])
        .onAppear {
            self.presenter.onAppear()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = MapInteractor()
        let router = MapRouter()
        let presenter = MapPresenter(interactor: interactor, router: router, uid: "1")
        presenter.pinItems = [PinItem(coordinate: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088))]
        
        return ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            MapView(presenter: presenter)
                .environment(\.colorScheme, scheme)
        }
    }
}
