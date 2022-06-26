//
//  MapView.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/06.
//

import SwiftUI
import MapKit
import DynamicOverlay
import PopupView

struct MapView: View {
    @ObservedObject var presenter: MapPresenter
    @EnvironmentObject var appDelegate: AppDelegate
    @EnvironmentObject var resultNotification: ResultNotification
    
    var myOverlayBehavior: some DynamicOverlayBehavior {
        MagneticNotchOverlayBehavior<Notch> { notch in
            switch notch {
            case .max:
                return .fractional(0.35)
            case .min:
                return .fractional(0.1)
            }
        }
        .onTranslation(self.presenter.onOverlaySheetTranslation)
        .notchChange(self.$presenter.notch)
        .disable(.max, self.presenter.notch == .min)
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: self.$presenter.region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .none,
                annotationItems: self.presenter.pinItems
            ) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    AvatarMapAnnotation(image: item.imageData != nil ? UIImage(data: item.imageData!) : nil)
                        .onTapGesture {
                            self.presenter.onAvatarMapAnnotationTap(item: item)
                        }
                        .offset(x: 0, y: -44)
                        .padding(.top, 44)
                }
            }
            .ignoresSafeArea(edges: [.trailing, .leading, .top])
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        LocationButton(onTap: {
                            withAnimation {
                                self.presenter.onLocationButtonTap(region: self.appDelegate.region)
                            }
                        })
                        .padding(0)
                    }
                    .cornerRadius(8)
                    .shadow(radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                    .padding(.bottom, 90)
                }
            }
            
            if self.presenter.overlaySheetType != .close {
                Color.black.opacity(0.2)
                    .onTapGesture {
                        self.presenter.onOverlaySheetBackgroundTap()
                    }
                    .ignoresSafeArea()
            } else {
                // 本来は不要だがelseでもViewを作っておかないと上記のViewが表示されないので仕方なく
                Color.black.opacity(0)
                    .frame(width: 0, height: 0, alignment: .topLeading)
            }
        }
        .dynamicOverlay(
            MapOverlaySheet {
                self.presenter.makeAbountOverlaySheet(resultNotification: self.resultNotification, locationAuthorizationStatus: self.appDelegate.locationAuthorizationStatus)
            }
        )
        .dynamicOverlayBehavior(myOverlayBehavior)
        .ignoresSafeArea(edges: [.top, .trailing, .leading])
        .onAppear {
            self.presenter.onAppear(initialRegion: self.appDelegate.region)
        }
        .onDisappear {
            self.presenter.onDisapper()
            self.resultNotification.hide()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static let appDelegate = AppDelegate()
    static let notification = ResultNotification()
    static let auth = Authentication()
    
    static var previews: some View {
        let interactor = MapInteractor()
        let router = MapRouter()
        let presenter = MapPresenter(interactor: interactor, router: router, uid: "1")
        presenter.pinItems = [PinItem(id: "previewId", coordinate: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088), createdAt: Date.now)]
        
        return ForEach([ColorScheme.light, ColorScheme.dark], id: \.self) { scheme in
            return   MapView(presenter: presenter)
                .environmentObject(appDelegate)
                .environmentObject(auth)
                .environmentObject(notification)
                .environment(\.colorScheme, scheme)
        }
    }
}
