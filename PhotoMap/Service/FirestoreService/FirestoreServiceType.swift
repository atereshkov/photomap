//
//  FirebaseServiceType.swift
//  PhotoMap
//
//  Created by Yury Kasper on 24.05.21.
//

import Combine
import Foundation

protocol FirestoreServiceType {
    func getUserMarkers() -> Future<[Marker], FirestoreError>
    func getCategories() -> Future<[Category], FirestoreError>
    func addUserMarker(with data: [String: Any]) -> Future<Bool, FirestoreError>
    func uploadPhoto(_ data: Data) -> Future<URL, FirestoreError>
}
