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
