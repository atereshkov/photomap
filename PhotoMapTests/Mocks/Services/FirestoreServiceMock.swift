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
    var error: FirestoreError?

    var image: UIImage?
    var userHasDocuments: Bool?
    var getMarkersCalled = false
    var getMarkersEndWithValues = false

    var getCategoriesCalled = false
    var getCategoriesEndWithValues = false
    var localImage: UIImage?
    var downloadImage: UIImage?
    var downloadImageEndWithImage = false
    var currentUser: User?
    var isEmptyPhotos = false
    var isEmptyCategories = false

    let categories = [
        Category(id: "1", name: "DEFAULT", color: "#368EDF"),
        Category(id: "2", name: "NATURE", color: "#578E18"),
        Category(id: "3", name: "FRIENDS", color: "#F4A523")
    ]

    lazy var photos = {
        // swiftlint:disable line_length
        [PhotoDVO(id: "1", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories[safe: 0], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
         PhotoDVO(id: "2", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories[safe: 0], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
         PhotoDVO(id: "3", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories[safe: 0], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
         PhotoDVO(id: "4", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories[safe: 1], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
         PhotoDVO(id: "5", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories[safe: 1], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
         PhotoDVO(id: "6", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories[safe: 1], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
         PhotoDVO(id: "7", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories[safe: 2], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
         PhotoDVO(id: "8", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories[safe: 2], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)),
         PhotoDVO(id: "9", image: UIImage(), imageUrls: ["url"], date: Date(), description: "", category: categories[safe: 2], coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        ]
        // swiftlint:enable line_length
    }()
}

extension FirestoreServiceMock: FirestoreServiceType {
    func getPhotos(for visibleRect: MKMapRect) -> AnyPublisher<[PhotoDVO], FirestoreError> {
        Future { [weak self] promise in
            if let error = self?.error { return promise(.failure(error)) }
            guard self?.isEmptyPhotos == false else { return promise(.success([])) }
            
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
            guard self?.isEmptyCategories == false,
                  let categories = self?.categories else { return promise(.success([])) }

            self?.getCategoriesEndWithValues = true
            promise(.success(categories))
        }
    }

    func addUserPhoto(with photo: UploadPhoto) -> AnyPublisher<Void, FirestoreError> {
        Future { [weak self] promise in
            if let error = self?.error { return promise(.failure(FirestoreError(error))) }

            promise(.success(()))
        }.eraseToAnyPublisher()
    }
    
    func getUserMarkers() -> AnyPublisher<[PhotoDVO], FirestoreError> {
        Future { [weak self] promise in
            self?.getMarkersCalled = true
            if let error = self?.error { return promise(.failure(.custom(error.message))) }
            guard self?.userHasDocuments != nil else {
                self?.getMarkersEndWithValues = true
                return promise(.success([]))
            }

            if self?.isEmptyPhotos == false, let photos = self?.photos {
                self?.getMarkersEndWithValues = true
                promise(.success(photos))
            }
        }.eraseToAnyPublisher()
    }
    
    func downloadImage(with url: URL?) -> Future<UIImage?, FirestoreError> {
        Future { [weak self] promise in
            
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
    
    func getCurrentUser() -> Future<User, FirestoreError> {
        Future { [weak self] promise in
            guard self?.userId != nil else { return promise(.failure(.noCurrentUserId)) }
            if let error = self?.error { return promise(.failure(error)) }
            guard let currentUser = self?.currentUser else { return promise(.failure(.custom("no current user"))) }
            return promise(.success(currentUser))
        }
    }
}
