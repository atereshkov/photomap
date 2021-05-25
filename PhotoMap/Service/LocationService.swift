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
    
    var isEnable: CurrentValueSubject<Bool, Never> { get }
    var status: PassthroughSubject<CLAuthorizationStatus, Never> { get }
    var location: CurrentValueSubject<CLLocation, Never> { get }

    var currentCoordinate: CLLocationCoordinate2D { get }
    var locationManager: CLLocationManager { get }
    
}

class LocationService: NSObject, LocationServiceType {
    
    private(set) var location = CurrentValueSubject<CLLocation, Never>(CLLocation.init())
    private(set) var isEnable = CurrentValueSubject<Bool, Never>(false)
    private(set) var status = PassthroughSubject<CLAuthorizationStatus, Never>()
    
    private let cancelBag = CancelBag()
    
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

        bind()
        locationManager.startUpdatingLocation()

        if #available(iOS 14.0, *) {
            self.status.send(self.locationManager.authorizationStatus)
        } else {
            self.status.send(CLLocationManager.authorizationStatus())
        }
    }

    private func bind() {
        status
            .sink { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .authorizedWhenInUse, .authorizedAlways:
                    self.isEnable.send(true)
                case .notDetermined:
                    self.locationManager.requestWhenInUseAuthorization()
                    self.isEnable.send(true)
                case .denied, .restricted:
                    self.isEnable.send(false)
                @unknown default:
                    return
                }
            }
            .store(in: cancelBag)
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
    }
    
}
