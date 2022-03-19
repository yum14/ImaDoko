//
//  AppDelegate.swift
//  ImaDoko (iOS)
//
//  Created by yum on 2022/02/27.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications
import MapKit

final class AppDelegate: UIResponder, ObservableObject {
    @Published var notificationToken: String?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    private let initialLocation = CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088)
    private let initialCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    
    private var location: CLLocationCoordinate2D? {
        didSet {
            guard let newLocation = self.location else {
                self.region = MKCoordinateRegion(center: initialLocation,
                                                 span: initialCoordinateSpan)
                return
            }
            
            guard let oldValue = oldValue else {
                self.region = MKCoordinateRegion(center: newLocation,
                                                 span: initialCoordinateSpan)
                return
            }

            if !(oldValue.latitude == newLocation.latitude && oldValue.longitude == newLocation.longitude) {
                // spanは現在表示中のものとする
                self.region = MKCoordinateRegion(center: newLocation,
                                                 span: self.region.span)
                return
            }
        }
    }
    
    private var locationManager : CLLocationManager?
    
    func setNotificationToken(_ newToken: String?) {
        self.notificationToken = newToken
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        FirebaseApp.configure()
        
        // notification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        
        // location
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.distanceFilter = 10
            locationManager!.activityType = .fitness
            locationManager!.startUpdatingLocation()
        }
        
        return true
    }
    
    // トークンを紐づける
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        completionHandler([])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        setNotificationToken(fcmToken)
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentlocation = locations.last else {
            return
        }
        
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentlocation.coordinate.latitude, currentlocation.coordinate.longitude)
        
        if let location = self.location {
            if !(location.latitude == newLocation.latitude && location.longitude == newLocation.longitude) {
                self.location = newLocation
            }
        } else {
            self.location = newLocation
        }
        print("緯度: ", newLocation.latitude, "経度: ", newLocation.longitude)
    }
}
