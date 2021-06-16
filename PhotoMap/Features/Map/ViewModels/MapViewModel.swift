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
    private let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    private let diContainer: DIContainerType
    private let locationService: LocationServiceType
    private let firestoreService: FirestoreServiceType

    // MARK: - Input
    private(set) var categoryButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var enableDiscoveryModeSubject = PassthroughSubject<GestureType, Never>()
    private(set) var navigationButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var photoButtonSubject = PassthroughSubject<CLLocationCoordinate2D?, Never>()
    private(set) var loadUserPhotosSubject = PassthroughSubject<MKMapRect, FirestoreError>()

    // MARK: - Output
    @Published private(set) var photos: [Photo] = []
    @Published private(set) var isShowUserLocation: Bool = true
    @Published private(set) var region: MKCoordinateRegion?
    @Published private(set) var modeButtonCollor: UIColor = Asset.followModeColor.color
    @Published private(set) var isFollowModeOn: Bool = true

    init(coordinator: MapCoordinator,
         diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.diContainer = diContainer
        self.locationService = diContainer.resolve()
        self.firestoreService = diContainer.resolve()

        super.init()

        transform()
    }

    private func transform() {
        locationService.isEnable
            .assign(to: \.isShowUserLocation, on: self)
            .store(in: cancelBag)

        locationService.location
            .sink { [weak self] location in
                guard let self = self,
                      self.isFollowModeOn else { return }

                self.region = MKCoordinateRegion(center: location.coordinate, span: self.coordinateSpan)
            }
            .store(in: cancelBag)

        categoryButtonSubject
            .sink { [weak self] _ in
                self?.switchFollowDiscoveryMode(disableFolowMode: true)
            }
            .store(in: cancelBag)

        enableDiscoveryModeSubject
            .sink { [weak self] _ in
                self?.switchFollowDiscoveryMode(disableFolowMode: true)
            }
            .store(in: cancelBag)

        photoButtonSubject
            .sink { [weak self] receiveCoordinate in
                guard let self = self else { return }

                self.switchFollowDiscoveryMode(disableFolowMode: true)
                let coordinate = receiveCoordinate != nil ? receiveCoordinate : self.locationService.currentCoordinate
                self.coordinator.showPhotoMenuAlertSubject.send(coordinate)
            }
            .store(in: cancelBag)

        navigationButtonSubject
            .sink { [weak self] _ in
                self?.switchFollowDiscoveryMode()
            }
            .store(in: cancelBag)

        locationService.status
            .filter { $0 == .denied }
            .map { _ in () }
            .subscribe(coordinator.disableLocationSubject)
            .store(in: cancelBag)

        loadUserPhotosSubject
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .flatMap { [unowned self] visibleRect in
                self.firestoreService.getPhotos(by: visibleRect)
            }
            .sink(receiveCompletion: сompletionHandler,
                  receiveValue: { [weak self] photos in self?.photos = photos })
            .store(in: cancelBag)
    }

    private func switchFollowDiscoveryMode(disableFolowMode: Bool = false) {
        isFollowModeOn = disableFolowMode ? !disableFolowMode : !isFollowModeOn
        modeButtonCollor = isFollowModeOn ? Asset.followModeColor.color : Asset.discoverModeColor.color
    }

    private func сompletionHandler(completion: Subscribers.Completion<FirestoreError>) {
        switch completion {
        case .failure(let error):
            coordinator.errorAlertSubject.send(error)
        case .finished:
            return
        }
    }

    private func isChangedCoordinate(last: CLLocationCoordinate2D) -> Bool {
        guard let previous = region?.center else { return true }

        return last.latitude != previous.latitude || last.longitude != previous.longitude
    }
}

extension MapViewModel: MKMapViewDelegate {

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        loadUserPhotosSubject.send(mapView.visibleMapRect)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let photoView = view as? PhotoMarkerView,
              let photoAnnotation = view.annotation as? PhotoAnnotation else { return }

        guard let url = photoAnnotation.imageUrl else { return }

        if !photoView.isLoadImage {
            firestoreService.downloadImage(by: url)
                .sink(receiveCompletion: self.сompletionHandler,
                      receiveValue: { image in
                        guard let image = image else { return }
                        photoView.loadImageSubject.send(image)
                      })
                .store(in: cancelBag)
        }
    }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let photoAnnotation = view.annotation as? PhotoAnnotation else { return }
        // Open FullPhoto screen
    }
}
