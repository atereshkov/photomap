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
}
