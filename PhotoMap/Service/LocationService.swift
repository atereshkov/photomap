//
//  LocationService.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 4/28/21.
//

import Foundation
import CoreLocation
import Combine

protocol LocationServiceType: NSObject {
    var status: PassthroughSubject<CLAuthorizationStatus, Never> { get }
    var location: CurrentValueSubject<CLLocation, Never> { get }

    var currentCoordinate: CLLocationCoordinate2D { get }
    var locationManager: CLLocationManager { get }
    
}

class LocationService: NSObject, LocationServiceType {
    
    private(set) var location = CurrentValueSubject<CLLocation, Never>(CLLocation.init())
    private(set) var status = PassthroughSubject<CLAuthorizationStatus, Never>()
    
    var currentCoordinate: CLLocationCoordinate2D {
        location.value.coordinate
    }

    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        return locationManager
    }()

    override init() {
        super.init()

        locationManager.startUpdatingLocation()

        status.send(self.locationManager.authorizationStatus)
    }    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        location.send(lastLocation)
    }

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        self.status.send(status)
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
}
