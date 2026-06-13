//
//  OrtungsUmgebungVM.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 13.06.26.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

/// ViewModel aus Vorlesung 6; verwaltet die Geräte-Ortung für die Map.
class OrtungsUmgebungVM: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationString = ""
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations.last?.coordinate.latitude.description ?? "<unbekannt>"
        let lon = locations.last?.coordinate.longitude.description ?? "<unbekannt>"
        locationString = "<\(lat), \(lon)>"
    }
}
