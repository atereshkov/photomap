//
//  LocationServiceMock.swift
//  PhotoMapTests
//
//  Created by Dzmitry Makarevich on 19.05.21.
//

import Foundation
import CoreLocation
import Combine
@testable import PhotoMap

class LocationServiceMock: NSObject, LocationServiceType {
    var isEnable = CurrentValueSubject<Bool, Never>(false)
    var status = PassthroughSubject<CLAuthorizationStatus, Never>()
    var location = CurrentValueSubject<CLLocation, Never>(CLLocation.init())
    
    var currentCoordinate: CLLocationCoordinate2D {
        location.value.coordinate
    }

    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        return locationManager
    }()

    private let cancelBag = CancelBag()

    override init() {
        super.init()

        status.send(.notDetermined)
        locationManager.startUpdatingLocation()
    }

    func enableService() {
        isEnable.send(true)
        status.send(.authorizedWhenInUse)
    }

    func disableService() {
        isEnable.send(false)
        status.send(.denied)
    }
}
