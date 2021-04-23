//
//  MapViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import Foundation
import Combine
import CoreLocation

class MapViewModel: NSObject {
    // MARK: - Variables
    private var coordinator: MapCoordinator
    private var location: CLLocation!
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        return locationManager
    }()

    // MARK: - Input
    @Published var tabTitle: String = "Map"
    @Published var followModeButtonTapped: Void = ()

    // MARK: - Output
    @Published var isShowUserLocation: Bool = false

    init(coordinator: MapCoordinator) {
        self.coordinator = coordinator
        super.init()

        transform()

        locationManager.startUpdatingLocation()
    }

    private func transform() {
        isShowUserLocation = checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
             return true
        case .denied:
            // Show alert telling users how to turn on permissions
            return false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return true
        case .restricted:
            // Show an alert letting them know what’s up
            return false
        case .authorizedAlways:
            return true
        @unknown default:
            fatalError()
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last as CLLocation?
    }
}
