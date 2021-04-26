//
//  MapViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine
import CoreLocation
import MapKit

class MapViewModel: NSObject {
    // MARK: - Variables
    private let cancelBag = CancelBag()
    private var coordinator: MapCoordinator
    private var location: CLLocation!
    private let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        return locationManager
    }()

    // MARK: - Input

    // MARK: - Output
    @Published var tabTitle: String
    @Published var isShowUserLocation: Bool = false

    init(coordinator: MapCoordinator) {
        self.coordinator = coordinator
        self.tabTitle = "Map"

        super.init()

        transform()
    }

    private func transform() {
        locationManager.startUpdatingLocation()

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

    func findMyLocation() -> MKCoordinateRegion? {
        guard let location = location else { return nil }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)

        return MKCoordinateRegion(center: center, span: coordinateSpan)
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last as CLLocation?
    }
}
