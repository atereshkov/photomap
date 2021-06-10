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
import MapKit

final class FirestoreService: FirestoreServiceType {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
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

                guard let documents = snapshot?.documents else { return promise(.success([])) }

                let categories = documents.map { Category(id: $0.documentID, dictionary: $0.data()) }
                promise(.success(categories))
            }
        }
    }

    func addUserPhoto(with photo: Photo) -> AnyPublisher<Void, FirestoreError> {
        uploadPhoto(with: photo.image)
            .flatMap { [unowned self] url -> Future<Void, FirestoreError> in
                self.savePhoto(data: photo.toDictionary(urls: [url]))
            }.eraseToAnyPublisher()
    }

    private func savePhoto(data: [String: Any]) -> Future<Void, FirestoreError> {
        Future { [weak self] promise in
            guard let currentUserId = self?.currentUserId else {return promise(.failure(.noCurrentUserId)) }

            let userPhotoPath = [Path.photosCollection,
                                 currentUserId,
                                 Path.userPhotosCollection].joined(separator: Separator.slash)
            guard let userPhotosRef = self?.db.collection(userPhotoPath) else {
                return promise(.failure(.unavailableLocalService))
            }

            userPhotosRef.addDocument(data: data) { error in
                if let error = error { return promise(.failure(FirestoreError(error))) }
            }

            promise(.success(()))
        }
    }

    private func uploadPhoto(with image: UIImage) -> Future<URL, FirestoreError> {
        Future { [weak self] promise in
            guard let imageData = image.pngData() else { return promise(.failure(.imageDecoding)) }

            guard let currentUserId = self?.currentUserId else {return promise(.failure(.noCurrentUserId)) }

            let imageName = [currentUserId, [Date().fullDateString, Path.imageType]
                                .joined(separator: Separator.point)].joined(separator: Separator.slash)

            guard let photoRef = self?.storage.reference(withPath: Path.userImages).child(imageName) else {
                return promise(.failure(.unavailableLocalService))
            }

            photoRef.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    return promise(.failure(FirestoreError(error)))
                }

                photoRef.downloadURL { (url, error) in
                    if let error = error { return promise(.failure(FirestoreError(error))) }
                    guard let receiveUrl = url else { return promise(.failure(.nonMatchingChecksum)) }
                    promise(.success(receiveUrl))
                }
            }
        }
    }

    func getUserMarkers(by visibleRect: MKMapRect) -> Future<[ReceivePhoto], FirestoreError> {
        Future { [weak self] promise in
            guard let currentUserId = self?.currentUserId else { return promise(.failure(.noCurrentUserId)) }
            let userPhotosReference = self?.db.collection(Path.photosCollection)
                                              .document(currentUserId)
                                              .collection(Path.userPhotosCollection)

            userPhotosReference?.getDocuments { snapshot, error in
                if let error = error { return promise(.failure(FirestoreError(error))) }
                guard let documents = snapshot?.documents else { return promise(.success([])) }

                var photos = [ReceivePhoto]()
                for document in documents {
                    let photo = ReceivePhoto(dictionary: document.data())
                    if visibleRect.contains(MKMapPoint(photo.toMapCoordinates())) {
                        photos.append(photo)
                    }
                }

                promise(.success(photos))
            }
        }
    }

    func getCategoryBy(by id: String) -> Future<Category, FirestoreError> {
        Future { [weak self] promise in
            guard self?.currentUserId != nil else { return promise(.failure(.noCurrentUserId)) }

            let categoriesReference = self?.db.collection(Path.categoriesCollection).document(id)

            categoriesReference?.getDocument { document, error in
                if let error = error { return promise(.failure(FirestoreError(error))) }
                guard let document = document,
                      let data = document.data() else { return promise(.failure(.nonMatchingChecksum)) }

                let category = Category(id: document.documentID, dictionary: data)
                promise(.success(category))
            }
        }
    }

    func downloadImage(by url: String) -> Future<UIImage?, FirestoreError> {
        Future { [weak self] promise in
            self?.storage
                .reference(forURL: url)
                .getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error { return promise(.failure(FirestoreError(error))) }
                    guard let data = data else { return promise(.failure(.imageDecoding)) }

                    promise(.success(UIImage(data: data)))
                }
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
