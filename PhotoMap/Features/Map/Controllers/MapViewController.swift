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

        mapView.delegate = viewModel
        mapView.register(PhotoMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }

    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.$photos
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { [weak self] photos in
                    if let annotations = self?.mapView?.annotations {
                        self?.mapView?.removeAnnotations(annotations)
                    }
                    photos.forEach { self?.mapView.addAnnotation(PhotoAnnotation(photo: $0)) }
            })
            .store(in: cancelBag)

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
            .subscribe(viewModel.categoryButtonSubject)
            .store(in: cancelBag)
        navigationButton.tapPublisher
            .subscribe(viewModel.navigationButtonSubject)
            .store(in: cancelBag)
        photoButton.tapPublisher
            .map { _ in nil }
            .subscribe(viewModel.photoButtonSubject)
            .store(in: cancelBag)
    }

    private func bindMapGestures() {
        guard let viewModel = viewModel else { return }

        mapView.allGestures()
            .subscribe(viewModel.enableDiscoveryModeSubject)
            .store(in: cancelBag)

        mapView.gesture(.longPress())
            .map { [weak self] gestureType in
                self?.getCoordinate(by: gestureType)
            }
            .filter { $0 != nil }
            .subscribe(viewModel.photoButtonSubject)
            .store(in: cancelBag)
    }

    private func getCoordinate(by gestureType: GesturePublisher.Output) -> CLLocationCoordinate2D? {
        let gesture = gestureType.get()
        guard gesture.state == .ended else { return nil }

        let touchLocation = gesture.location(in: self.mapView)
        let coordinate = self.mapView.convert(touchLocation, toCoordinateFrom: self.mapView)

        return coordinate
    }
}
