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
    var userHasDocuments: Bool?
    var getMarkersCalled = false
    var getMarkersEndWithValues = false
    var categories: [PhotoMap.Category]?
    var getCategoriesCalled = false
    var getCategoriesEndWithValues = false
}

extension FirestoreServiceMock: FirestoreServiceType {
    func getPhotos(for visibleRect: MKMapRect) -> AnyPublisher<[Photo], FirestoreError> {
        Future { [weak self] promise in
            if let error = self?.error { return promise(.failure(error)) }
            let photos = self?.photos ?? []
            promise(.success(photos))
        }.eraseToAnyPublisher()
    }

    func getCategoryBy(by id: String) -> Future<PhotoMap.Category, FirestoreError> {
        Future { [weak self] promise in
            self?.getCategoriesCalled = true
            if let error = self?.error { return promise(.failure(error)) }
            guard let categories = self?.categories,
                  let category = categories.filter({ $0.id == id })[safe: 0] else {
                return promise(.failure(.nonMatchingChecksum))
            }

            self?.getCategoriesEndWithValues = true
            promise(.success(category))
        }
    }

    func downloadImage(by url: String) -> Future<UIImage?, FirestoreError> {
        Future { promise in promise(.success(UIImage())) }
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
}
