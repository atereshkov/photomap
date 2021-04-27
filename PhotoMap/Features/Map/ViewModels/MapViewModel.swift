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

class MapViewModel: NSObject, MapViewModelType {
    // MARK: - Variables
    private let cancelBag = CancelBag()
    private let coordinator: MapCoordinator
    private var location: CLLocation!
    private let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        return locationManager
    }()

    // MARK: - Input
    @Published private(set) var isFollowModeOn: Bool = true

    // MARK: - Output
    @Published private(set) var tabTitle: String = L10n.Main.TabBar.Map.title
    @Published private(set) var isShowUserLocation: Bool = true
    @Published private(set) var region: MKCoordinateRegion?
    @Published private(set) var modeButtonCollor: UIColor = Asset.followModeColor.color

    init(coordinator: MapCoordinator) {
        self.coordinator = coordinator
        super.init()

        transform()
    }

    private func transform() {
        locationManager.startUpdatingLocation()

        isShowUserLocation = checkLocationAuthorization()
        $isFollowModeOn
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self = self,
                      let location = self.location else { return }

                self.region = MKCoordinateRegion(center: location.coordinate, span: self.coordinateSpan)
            }
            .store(in: cancelBag)
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

    func switchFollowDiscoveryMode() {
        isFollowModeOn = !isFollowModeOn
        modeButtonCollor = isFollowModeOn ? Asset.followModeColor.color : Asset.discoverModeColor.color
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last as CLLocation?

        if isFollowModeOn {
            region = MKCoordinateRegion(center: location.coordinate,
                                        span: coordinateSpan)
        }
    }
}
