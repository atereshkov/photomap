//
//  FirestoreServiceMock.swift
//  PhotoMapTests
//
//  Created by yurykasper on 27.05.21.
//

import Combine
import MapKit
@testable import PhotoMap

class FirestoreServiceMock {
    var userId: String?
    var error: FirestoreError?
    var markers: [Marker]?
    var photos: [Photo]?
    var image: UIImage?
    var userHasDocuments: Bool?
    var getMarkersCalled = false
    var getMarkersEndWithValues = false
    var categories: [PhotoMap.Category]?
    var getCategoriesCalled = false
    var getCategoriesEndWithValues = false
    var localImage: UIImage?
    var downloadImage: UIImage?
    var downloadImageEndWithImage = false
}

extension FirestoreServiceMock: FirestoreServiceType {
    func getPhotos(for visibleRect: MKMapRect) -> AnyPublisher<[Photo], FirestoreError> {
        Future { [weak self] promise in
            if let error = self?.error { return promise(.failure(error)) }
            let photos = self?.photos ?? []
            promise(.success(photos))
        }.eraseToAnyPublisher()
    }

    func downloadImage(by url: String) -> Future<UIImage?, FirestoreError> {
        Future { [weak self] promise in
            if let error = self?.error { return promise(.failure(error)) }

            promise(.success(self?.image)) }
    }

    func getCategories() -> Future<[PhotoMap.Category], FirestoreError> {
        Future { [weak self] promise in
            self?.getCategoriesCalled = true
            if let error = self?.error { return promise(.failure(error)) }
            guard let categories = self?.categories else { return promise(.success([])) }

            self?.getCategoriesEndWithValues = true
            promise(.success(categories))
        }
    }

    func addUserPhoto(with photo: Photo) -> AnyPublisher<Void, FirestoreError> {
        Future { [weak self] promise in
            if let error = self?.error { return promise(.failure(.custom(error.message))) }

            promise(.success(()))
        }.eraseToAnyPublisher()
    }
    
    func getUserMarkers() -> Future<[Marker], FirestoreError> {
        Future { [weak self] promise in
            self?.getMarkersCalled = true
            guard self?.userId != nil else { return promise(.failure(.noCurrentUserId)) }
            if let error = self?.error { return promise(.failure(.custom(error.message))) }
            guard self?.userHasDocuments != nil else {
                self?.getMarkersEndWithValues = true
                return promise(.success([]))
            }

            if let markers = self?.markers {
                self?.getMarkersEndWithValues = true
                promise(.success(markers))
            }
        }
    }
    
    func downloadImage(with url: URL?) -> Future<UIImage?, FirestoreError> {
        Future { [weak self] promise in
            guard self?.userId != nil else { return promise(.failure(.noCurrentUserId)) }
            
            if let localImage = self?.localImage {
                self?.downloadImageEndWithImage = true
                return promise(.success(localImage))
            }
            if let error = self?.error {
                return promise(.failure(.custom(error.localizedDescription)))
            }
            
            guard let image = self?.downloadImage else { return promise(.failure(.custom("no image provided"))) }
            self?.downloadImageEndWithImage = true
            return promise(.success(image))
        }
    }

    func setPhotos() {
        // swiftlint:disable line_length
        photos = [
            Photo(id: "1", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories?[safe: 1], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
            Photo(id: "2", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories?[safe: 1], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
            Photo(id: "3", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories?[safe: 1], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
            Photo(id: "4", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories?[safe: 2], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
            Photo(id: "5", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories?[safe: 2], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
            Photo(id: "6", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories?[safe: 2], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
            Photo(id: "7", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories?[safe: 0], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
            Photo(id: "8", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories?[safe: 0], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
            Photo(id: "9", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories?[safe: 0], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        ]
        // swiftlint:enable line_length
    }

    func setCategories() {
        categories = [
            Category(id: "1", name: "DEFAULT", color: "#368EDF"),
            Category(id: "2", name: "NATURE", color: "#578E18"),
            Category(id: "3", name: "FRIENDS", color: "#F4A523")
        ]
    }
}
