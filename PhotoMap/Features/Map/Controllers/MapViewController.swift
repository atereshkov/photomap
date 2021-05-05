//
//  MapViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import MapKit
import Combine

class MapViewController: BaseViewController {
    // MARK: - Variables
    private var viewModel: MapViewModel?
    private let cancelBag = CancelBag()

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var navigationButton: UIButton!
    @IBOutlet private weak var photoButton: UIButton!
    @IBOutlet private weak var categoryButton: UIButton!
    
    static func newInstanse(viewModel: MapViewModel) -> MapViewController {
        let mapVC = StoryboardScene.Map.mapViewController.instantiate()
        mapVC.viewModel = viewModel
        mapVC.tabBarItem.image = .actions

        return mapVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setOpacityBackgroundNavigationBar()
        bind()
        bindMapGestures()
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
            }
            .store(in: cancelBag)

        viewModel.$modeButtonCollor
            .assign(to: \.tintColor, on: navigationButton)
            .store(in: cancelBag)

        categoryButton.tapPublisher
            .sink { _ in
                viewModel.categoryButtonSubject.send(())
            }
            .store(in: cancelBag)
        navigationButton.tapPublisher
            .sink { _ in
                viewModel.navigationButtonSubject.send(())
            }
            .store(in: cancelBag)
        photoButton.tapPublisher
            .sink { _ in
                viewModel.photoButtonSubject.send(())
            }
            .store(in: cancelBag)
    }

    private func bindMapGestures() {
        guard let viewModel = viewModel else { return }

        mapView.allGestures()
            .sink { _ in
                viewModel.enableDiscoveryModeSubject.send(())
            }
            .store(in: cancelBag)

        mapView.gesture(.longPress())
            .sink { _ in
                viewModel.photoButtonSubject.send(())
            }
            .store(in: cancelBag)
    }
}
