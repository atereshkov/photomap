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
    @IBOutlet private weak var photoButton: UIButton!
    @IBOutlet private weak var categoryButton: UIButton!
    
    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.cornerRadius = button.frame.size.height / 2
        button.frame.size = CGSize(width: 30, height: 30)
        button.clipsToBounds = true
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear

        return button
    }()
    
    static func newInstanse(viewModel: MapViewModel) -> MapViewController {
        let mapVC = StoryboardScene.Map.mapViewController.instantiate()
        mapVC.viewModel = viewModel
        mapVC.tabBarItem.image = .actions
        mapVC.tabBarItem.title = L10n.Main.TabBar.Map.title

        return mapVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setOpacityBackgroundNavigationBar()
        setupUI()
        bind()
    }

    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.$modeButtonTintColor
            .assign(to: \.tintColor, on: userTrackingButton)
            .store(in: cancelBag)
        viewModel.$userTrackingMode
            .assign(to: \.userTrackingMode, on: mapView)
            .store(in: cancelBag)
        categoryButton.tapPublisher
            .subscribe(viewModel.categoryButtonSubject)
            .store(in: cancelBag)
        photoButton.tapPublisher
            .map { _ in nil }
            .subscribe(viewModel.photoButtonSubject)
            .store(in: cancelBag)

        mapView.gesture(.tap())
            .subscribe(viewModel.tapMapViewGestureSubject)
            .store(in: cancelBag)
        mapView.gesture(.longPress())
            .map { [weak self] gestureType in
                self?.getCoordinate(by: gestureType)
            }
            .filter { $0 != nil }
            .subscribe(viewModel.photoButtonSubject)
            .store(in: cancelBag)

        viewModel.$photos
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] photos in
                    if let annotations = self?.mapView?.annotations {
                        self?.mapView?.removeAnnotations(annotations)
                    }
                    photos.forEach { self?.mapView.addAnnotation(PhotoAnnotation(photo: $0)) }
            })
            .store(in: cancelBag)
    }

    private func getCoordinate(by gestureType: GestureType) -> CLLocationCoordinate2D? {
        let gesture = gestureType.get()
        guard gesture.state == .ended else { return nil }

        let touchLocation = gesture.location(in: self.mapView)
        let coordinate = self.mapView.convert(touchLocation, toCoordinateFrom: self.mapView)

        return coordinate
    }

    private func setupUI() {
        mapView.showsUserLocation = true
        
        mapView.delegate = viewModel
        mapView.register(PhotoMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        view.addSubview(userTrackingButton)

        userTrackingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: 5).isActive = true
        userTrackingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -50).isActive = true
        userTrackingButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        userTrackingButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
}
