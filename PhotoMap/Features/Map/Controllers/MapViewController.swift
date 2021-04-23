//
//  MapViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseViewController, MKMapViewDelegate {
    // MARK: - Variables
    private let locationManager = CLLocationManager()
    private var viewModel: MapViewModel?

    @IBOutlet private weak var mapView: MKMapView!

    static func newInstanse(viewModel: MapViewModel) -> MapViewController {
        // init Map.storyboard -- MapViewController.instantiate()
        let mapVC = MapViewController()
        mapVC.setOpacityBackgroundNavigationBar()
        mapVC.viewModel = viewModel

        return mapVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        checkLocationServices()
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .denied:
            // Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted:
            // Show an alert letting them know what’s up
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
}
