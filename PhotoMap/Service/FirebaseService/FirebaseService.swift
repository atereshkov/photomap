//
//  FirebaseService.swift
//  PhotoMap
//
//  Created by Yury Kasper on 24.05.21.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore

// swiftlint:disable line_length

enum FirestoreErrorType: Error {
    case noCurrentUserId
    case custom(String)
    
    var description: String {
        switch self {
        case .noCurrentUserId:
            return "User is not authorized"
        case .custom(let message):
            return message
        }
    }
}

final class FirebaseService: FirebaseServiceType {
    private struct Path {
        static let photosCollection = "photos"
        static let userPhotosCollection = "user_photos"
    }
    
    let db = Firestore.firestore()
    let currentUserId = Auth.auth().currentUser?.uid
    
    func getUserMarkers() -> Future<[Marker], FirestoreErrorType> {
        return Future { [weak self] promise in
            guard let currentUserId = self?.currentUserId else {
                promise(.failure(.noCurrentUserId))
                return
            }
            let userPhotosReference = self?.db.collection([Path.photosCollection, currentUserId, Path.userPhotosCollection].joined(separator: "/"))
            userPhotosReference?.order(by: "date", descending: true).getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(.custom(error.localizedDescription)))
                } else {
                    guard let documents = snapshot?.documents else {
                        promise(.failure(.custom("no documents")))
                        return
                    }
                    var markers = [Marker]()
                    for document in documents {
                        let marker = Marker(dictionary: document.data())
                        markers.append(marker)
                    }
                    promise(.success(markers))
                }
            }
        }
    }
}

// swiftlint:enable line_length
