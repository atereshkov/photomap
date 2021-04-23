//
//  MapViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import MapKit
import Combine

class MapViewController: BaseViewController, MKMapViewDelegate {
    // MARK: - Variables
    private var viewModel: MapViewModel?
    private var cancellable = Set<AnyCancellable>()

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var followModeButton: UIButton!
    
    static func newInstanse(viewModel: MapViewModel) -> MapViewController {
        let mapVC = StoryboardScene.Map.mapViewController.instantiate()
        mapVC.viewModel = viewModel
        mapVC.tabBarItem.image = .actions

        return mapVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setOpacityBackgroundNavigationBar()
        mapView?.delegate = self

        bind()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.$tabTitle
            .sink(receiveValue: { [weak self] title in
                self?.tabBarItem.title = title
            })
            .store(in: &cancellable)

        viewModel.$isShowUserLocation
            .sink(receiveValue: {[weak self] isShow in
                self?.mapView?.showsUserLocation = isShow
            })
            .store(in: &cancellable)

//        followModeButton.tapPublisher
//            .assign(to: &viewModel.followModeButtonTapped)
    }

    @IBAction private func findMyLocation(_ sender: Any) {
/*
        guard let location = location else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
 */
    }

}
