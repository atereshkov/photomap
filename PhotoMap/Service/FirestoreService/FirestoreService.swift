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

final class FirestoreService: FirestoreServiceType {
    private struct Path {
        static let categoriesCollection = "categories"
        static let photosCollection = "photos"
        static let userPhotosCollection = "user_photos"
    }
    
    let db = Firestore.firestore()
    let currentUserId = Auth.auth().currentUser?.uid
    
    func getUserMarkers() -> Future<[Marker], FirestoreError> {
        return Future { [weak self] promise in
            guard let currentUserId = self?.currentUserId else {
                promise(.failure(.noCurrentUserId))
                return
            }
            let userPhotosReference = self?.db.collection([Path.photosCollection, currentUserId,
                                                           Path.userPhotosCollection].joined(separator: "/"))
            userPhotosReference?.order(by: "date", descending: true).getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(.custom(error.localizedDescription)))
                } else {
                    guard let documents = snapshot?.documents else {
                        promise(.success([]))
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

    func getCategories() -> Future<[Category], FirestoreError> {
        Future { [weak self] promise in
            guard let self = self else {
                return promise(.failure(.custom("Local service unavailable")))
            }

            let categoryReference = self.db.collection(Path.categoriesCollection)
            categoryReference.getDocuments { snapshot, error in
                if let error = error {
                    return promise(.failure(.custom(error.localizedDescription)))
                }

                guard let documents = snapshot?.documents else { return promise(.success([])) }

                var categories = [Category]()
                for document in documents {
                    var data = document.data()
                    data["id"] = document.documentID

                    categories.append(Category(dictionary: data))
                }
                promise(.success(categories))
            }
        }
    }
}
