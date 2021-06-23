//
//  FirebaseServiceType.swift
//  PhotoMap
//
//  Created by Yury Kasper on 24.05.21.
//

import Combine
import MapKit
import Foundation

protocol FirestoreServiceType {
    func getUserMarkers() -> Future<[Marker], FirestoreError>
    func getCategories() -> Future<[Category], FirestoreError>
    func getCategoryBy(by id: String) -> Future<Category, FirestoreError>
    func addUserPhoto(with photo: Photo) -> AnyPublisher<Void, FirestoreError>
    func getPhotos(for visibleRect: MKMapRect) -> AnyPublisher<[Photo], FirestoreError>
    func downloadImage(by url: String) -> Future<UIImage?, FirestoreError>
}
