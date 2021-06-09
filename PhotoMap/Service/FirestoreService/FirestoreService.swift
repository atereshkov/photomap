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
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference(withPath: Path.userImages)
    private let currentUserId = Auth.auth().currentUser?.uid
    
    func getUserMarkers() -> Future<[Marker], FirestoreError> {
        return Future { [weak self] promise in
            guard let currentUserId = self?.currentUserId else {
                promise(.failure(.noCurrentUserId))
                return
            }
            let userPhotosReference = self?.db.collection([Path.photosCollection,
                                                           currentUserId,
                                                           Path.userPhotosCollection]
                                                            .joined(separator: Separator.slash))
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

    func addUserPhoto(with photo: Photo) -> Future<Void, FirestoreError> {
        Future { [weak self] promise in
            guard let imageData = photo.image.pngData() else {
                return promise(.failure(.custom("Image error")))
            }
            guard let self = self else {
                return promise(.failure(.unavailableLocalService))
            }
            guard let currentUserId = self.currentUserId else {
                return promise(.failure(.noCurrentUserId))
            }

            let imageName = [currentUserId, [Date().fullDateString, Path.imageType]
                                .joined(separator: Separator.point)].joined(separator: Separator.slash)
            let photoRef = self.storage.child(imageName)

            var downloadUrl: URL?
            photoRef.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    return promise(.failure(FirestoreError(error)))
                }

                photoRef.downloadURL { (url, error) in
                    if let error = error { return promise(.failure(FirestoreError(error))) }
                    downloadUrl = url
                }
            }
            guard let downloadUrl = downloadUrl else { return promise(.failure(.nonMatchingChecksum)) }

            let userPhotosRef = self.db.collection([Path.photosCollection,
                                                    currentUserId,
                                                    Path.userPhotosCollection].joined(separator: Separator.slash))
            userPhotosRef.addDocument(data: photo.toDictionary(urls: [downloadUrl])) { error in
                if let error = error { return promise(.failure(FirestoreError(error))) }
            }

            promise(.success(()))
        }
    }
}

extension FirestoreService {
    private struct Path {
        static let categoriesCollection = "categories"
        static let photosCollection = "photos"
        static let userPhotosCollection = "user_photos"
        static let userImages = "Photo"
        static let imageType = "png"
    }

    private struct Separator {
        static let point: String = "."
        static let slash: String = "/"
    }
}
