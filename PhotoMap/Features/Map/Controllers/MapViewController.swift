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
    private let cancelBag = CancelBag()

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
            .store(in: cancelBag)

        viewModel.$isShowUserLocation
            .assign(to: \.showsUserLocation, on: mapView)
            .store(in: cancelBag)

        viewModel.$region
            .sink { [weak self] region in
                guard let region = region else { return }
                self?.mapView.setRegion(region, animated: true)
            }.store(in: cancelBag)

        viewModel.$modeButtonCollor
            .assign(to: \.tintColor, on: followModeButton)
            .store(in: cancelBag)

        followModeButton.publisher(for: .touchUpInside)
            .sink { _ in
                viewModel.switchFollowDiscoveryMode()
            }
            .store(in: cancelBag)
    }

}
