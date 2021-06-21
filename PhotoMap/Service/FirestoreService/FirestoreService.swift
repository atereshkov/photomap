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
    private let fileManagerService: FileManagerServiceType
    
    init(fileManagerService: FileManagerServiceType) {
        self.fileManagerService = fileManagerService
    }
    
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
                    let markers = documents.map { Marker(dictionary: $0.data()) }
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
        uploadPhoto(with: photo.image, and: photo.date.toString)
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

    private func uploadPhoto(with image: UIImage, and date: String) -> Future<URL, FirestoreError> {
        Future { [weak self] promise in
            guard let imageData = image.pngData() else { return promise(.failure(.imageDecoding)) }

            guard let currentUserId = self?.currentUserId else {return promise(.failure(.noCurrentUserId)) }

            let imageName = [currentUserId, [date, Path.imageType]
                                .joined(separator: Separator.point)].joined(separator: Separator.slash)

            guard let photoRef = self?.storage.child(imageName) else {
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
    
    func downloadImage(with url: URL?) -> Future<UIImage?, FirestoreError> {
        Future { [weak self] promise in
            guard self?.currentUserId != nil else { return promise(.failure(.noCurrentUserId)) }
            guard let url = url else { return promise(.failure(.custom(L10n.FirestoreError.WrongURL.message))) }
            
            let fileName = "\(url.absoluteString).\(Path.imageType)"
            guard let fileURL = self?.fileManagerService.configureFilePath(for: fileName) else {
                return promise(.failure(.custom(L10n.FirestoreError.WrongPath.message)))
            }
            
            if let localImageData = try? Data(contentsOf: fileURL) {
                return promise(.success(UIImage(data: localImageData)))
            }
            
            let photoReference = Storage.storage().reference(forURL: url.absoluteString)
            photoReference.write(toFile: fileURL) { url, error in
                if let error = error {
                    return promise(.failure(.custom(error.localizedDescription)))
                }
                guard let url = url, let imageData = try? Data(contentsOf: url) else { return promise(.failure(.imageDecoding)) }
                return promise(.success(UIImage(data: imageData)))
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
