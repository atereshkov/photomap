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
import FirebaseStorage

final class FirestoreService: FirestoreServiceType {
    private struct Path {
        static let categoriesCollection = "categories"
        static let photosCollection = "photos"
        static let userPhotosCollection = "user_photos"
        static let userImages = "Photo"
    }
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference(withPath: Path.userImages)
    private let currentUserId = Auth.auth().currentUser?.uid
    
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
        return Future { [weak self] promise in
            guard self?.currentUserId != nil else {
                promise(.failure(.noCurrentUserId))
                return
            }
            let categoriesReference = self?.db.collection(Path.categoriesCollection)
            categoriesReference?.getDocuments { snapshot, error in
                if let error = error {
                    return promise(.failure(FirestoreError(error)))
                }

                guard let documents = snapshot?.documents else {
                    return promise(.failure(.noMarkersCategories))
                }
                let categories = documents.map { Category(id: $0.documentID, dictionary: $0.data()) }
                promise(.success(categories))
            }
        }
    }
    
    func addUserMarker(with data: [String: Any]) -> Future<Bool, FirestoreError> {
        Future { [weak self] promise in
            guard let self = self else {
                return promise(.failure(.unavailableLocalService))
            }
            guard let currentUserId = self.currentUserId else {
                return promise(.failure(.noCurrentUserId))
            }

            let userPhotosRef = self.db.collection([Path.photosCollection,
                                           currentUserId,
                                           Path.userPhotosCollection].joined(separator: "/"))
            userPhotosRef.addDocument(data: data)

            return promise(.success(true))
        }
    }

    func uploadPhoto(_ data: Data = Data()) -> Future<URL, FirestoreError> {
        Future { [weak self] promise in
            guard let self = self else {
                return promise(.failure(.unavailableLocalService))
            }
            guard let currentUserId = self.currentUserId else {
                return promise(.failure(.noCurrentUserId))
            }

            let dateString = String(Date().description.trim().map { $0 == " " ? "-" : $0 })
            let imageName = [currentUserId, [dateString, "png"].joined(separator: ".")].joined(separator: "/")
            let photoRef = self.storage.child(imageName)

            photoRef.putData(data, metadata: nil) { (_, error) in
                if let error = error {
                    return promise(.failure(FirestoreError(error)))
                }

                photoRef.downloadURL { (url, error) in
                    if let error = error {
                        return promise(.failure(FirestoreError(error)))
                    }
                    guard let downloadURL = url else {
                        return promise(.failure(.nonMatchingChecksum))
                    }

                    promise(.success(downloadURL))
                }
            }
        }
    }
}
