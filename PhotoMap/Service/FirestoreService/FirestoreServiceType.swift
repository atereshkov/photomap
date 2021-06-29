//
//  FirebaseServiceType.swift
//  PhotoMap
//
//  Created by Yury Kasper on 24.05.21.
//

import Combine
import MapKit

protocol FirestoreServiceType {
    func getUserMarkers() -> AnyPublisher<[PhotoDVO], FirestoreError>
    func getCategories() -> Future<[Category], FirestoreError>
    func addUserPhoto(with photo: UploadPhoto) -> AnyPublisher<Void, FirestoreError>
    func getPhotos(for visibleRect: MKMapRect) -> AnyPublisher<[PhotoDVO], FirestoreError>
    func downloadImage(with: URL?) -> Future<UIImage?, FirestoreError>
}
