//
//  FirebaseServiceType.swift
//  PhotoMap
//
//  Created by Yury Kasper on 24.05.21.
//

import Combine
import MapKit

protocol FirestoreServiceType {
    func getUserMarkers() -> Future<[Marker], FirestoreError>
    func getCategories() -> Future<[Category], FirestoreError>
    func addUserPhoto(with photo: Photo) -> AnyPublisher<Void, FirestoreError>
    func getPhotos(for visibleRect: MKMapRect) -> AnyPublisher<[Photo], FirestoreError>
    func downloadImage(with: URL?) -> Future<UIImage?, FirestoreError>
    func getCurrentUser() -> Future<User, FirestoreError>
}
