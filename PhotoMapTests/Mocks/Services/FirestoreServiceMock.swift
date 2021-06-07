//
//  FirestoreServiceMock.swift
//  PhotoMapTests
//
//  Created by yurykasper on 27.05.21.
//

import Combine
import Foundation
@testable import PhotoMap

class FirestoreServiceMock {
    var userId: String?
    var error: FirestoreError?
    var markers: [Marker]?
    var userHasDocuments: Bool?
    var getMarkersCalled = false
    var getMarkersEndWithValues = false
}

extension FirestoreServiceMock: FirestoreServiceType {
    func getCategories() -> Future<[PhotoMap.Category], FirestoreError> {
        Future { [weak self] promise in
            if let error = self?.error {
                promise(.failure(.custom(error.message)))
                return
            }
            return promise(.success([Category(id: "123", name: "First", color: "#000000"),
                                     Category(id: "456", name: "Second", color: "#000fff"),
                                     Category(id: "789", name: "Third", color: "#ffffff")]))
        }
    }

    func addUserMarker(with data: [String: Any]) -> Future<Bool, FirestoreError> {
        Future { [weak self] promise in
            if let error = self?.error {
                promise(.failure(.custom(error.message)))
                return
            }
            return promise(.success(true))
        }
    }

    func uploadPhoto(_ data: Data) -> Future<URL, FirestoreError> {
        Future { [weak self] promise in
            if let error = self?.error {
                promise(.failure(.custom(error.message)))
                return
            }
            // swiftlint:disable force_unwrapping
            return promise(.success(URL(string: "https://google.com")!))
            // swiftlint:enable force_unwrapping
        }
    }
    
    func getUserMarkers() -> Future<[Marker], FirestoreError> {
        getMarkersCalled = true
        return Future { [weak self] promise in
            guard self?.userId != nil else {
                promise(.failure(.noCurrentUserId))
                return
            }
            if let error = self?.error {
                promise(.failure(.custom(error.message)))
                return
            }
            guard self?.userHasDocuments != nil else {
                promise(.success([]))
                self?.getMarkersEndWithValues = true
                return
            }
            if let markers = self?.markers {
                promise(.success(markers))
                self?.getMarkersEndWithValues = true
                return
            }
        }
    }
}
