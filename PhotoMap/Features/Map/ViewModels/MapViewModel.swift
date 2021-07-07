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
    private weak var coordinator: MapCoordinator!
    private let diContainer: DIContainerType
    private let locationService: LocationServiceType
    private let firestoreService: FirestoreServiceType

    // MARK: - Input
    private(set) var categoryButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var photoButtonSubject = PassthroughSubject<CLLocationCoordinate2D?, Never>()
    private(set) var loadUserPhotosSubject = PassthroughSubject<MKMapRect, FirestoreError>()
    private(set) var tapMapViewGestureSubject = PassthroughSubject<GestureType, Never>()

    // MARK: - Output
    @Published private(set) var photos: [PhotoDVO] = []
    @Published private(set) var visiblePhotos: [PhotoDVO] = []
    @Published private(set) var filteredCategories: [Category] = []
    @Published private(set) var modeButtonTintColor: UIColor = Asset.followModeColor.color
    @Published private(set) var userTrackingMode: MKUserTrackingMode = .follow

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
        categoryButtonSubject
            .map { [weak self] _ -> Void in return self?.enableDiscoveryMode() ?? () }
            .subscribe(coordinator.showCategoriesScreenSubject)
            .store(in: cancelBag)

        photoButtonSubject
            .sink { [weak self] receiveCoordinate in
                guard let self = self else { return }

                self.enableDiscoveryMode()
                let coordinate = receiveCoordinate != nil ? receiveCoordinate : self.locationService.currentCoordinate
                self.coordinator.showPhotoMenuAlertSubject.send(coordinate)
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
                self.firestoreService.getPhotos(for: visibleRect)
            }
            .sink(receiveCompletion: сompletionHandler,
                  receiveValue: { [weak self] photos in
                    self?.photos = photos })
            .store(in: cancelBag)

        tapMapViewGestureSubject
            .sink(receiveValue: { [weak self] _ in self?.enableDiscoveryMode()})
            .store(in: cancelBag)

        coordinator.doneButtonPressedWithCategoriesSubject
            .assign(to: \.filteredCategories, on: self)
            .store(in: cancelBag)

        $filteredCategories
            .map { [weak self] categories -> [PhotoDVO] in
                let filteredCategoryIds = categories.map { $0.id }

                return self?.photos.filter { photo in
                    guard let id = photo.category?.id else { return false }
                    return filteredCategoryIds.contains(id)
                } ?? []
            }
            .assign(to: \.visiblePhotos, on: self)
            .store(in: cancelBag)

        $photos
            .combineLatest($filteredCategories)
            .sink(receiveValue: { [weak self] photos, categories in
                if categories.isEmpty {
                    self?.visiblePhotos = photos
                } else {
                    self?.filteredCategories = categories
                }
            })
            .store(in: cancelBag)
    }

    private func enableDiscoveryMode() {
        userTrackingMode = .none
    }

    private func сompletionHandler(completion: Subscribers.Completion<FirestoreError>) {
        switch completion {
        case .failure(let error):
            coordinator.errorAlertSubject.send(error)
        case .finished:
            return
        }
    }
    
    // MARK: - deinit
    deinit {
        cancelBag.cancel()
    }
}

extension MapViewModel: MKMapViewDelegate {

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        loadUserPhotosSubject.send(mapView.visibleMapRect)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        switch annotation {
        case is PhotoAnnotation:
            guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: PhotoMarkerView.className) else {
                return PhotoMarkerView(annotation: annotation, reuseIdentifier: PhotoMarkerView.className)
            }
            
            return view
        case is MKClusterAnnotation:
            guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: PhotoClusterView.className) else {
                return PhotoClusterView(annotation: annotation, reuseIdentifier: PhotoClusterView.className)
            }
            
            return view
        default:
            return nil
        }
        
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let photoView = view as? PhotoMarkerView,
              let photoAnnotation = view.annotation as? PhotoAnnotation else {
            return
        }

        guard let url = photoAnnotation.imageUrl else { return }

        if photoView.detailImage == nil {
            firestoreService.downloadImage(with: URL(string: url))
                .sink(receiveCompletion: сompletionHandler,
                      receiveValue: { photoView.detailImage = $0 })
                .store(in: cancelBag)
        }
    }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let photoAnnotation = view.annotation as? PhotoAnnotation else { return }

        coordinator.showFullPhotoSubject.send(photoAnnotation.photo)
    }

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        switch mode {
        case .follow:
            modeButtonTintColor = Asset.followModeColor.color
        case .none:
            modeButtonTintColor = Asset.discoverModeColor.color
        case .followWithHeading:
            enableDiscoveryMode()
        @unknown default:
            enableDiscoveryMode()
        }
    }
}
