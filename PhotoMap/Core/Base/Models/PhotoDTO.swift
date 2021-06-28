//
//  PhotoDTO.swift
//  PhotoMap
//
//  Created by yurykasper on 24.05.21.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct PhotoDTO {
    var id: String = ""
    var images: [String]
    var date: Date = Date()
    var description: String = ""
    var category: String
    var geopoint: GeoPoint

    init(snapshot: QueryDocumentSnapshot) {
        let dictionary = snapshot.data()

        id = snapshot.documentID
        category = dictionary[PhotoNames.category.rawValue] as? String ?? ""
        let timestamp = dictionary[PhotoNames.date.rawValue] as? Timestamp ?? Timestamp(date: Date())
        date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        description = dictionary[PhotoNames.description.rawValue] as? String ?? ""
        images = dictionary[PhotoNames.images.rawValue] as? [String] ?? []
        geopoint = dictionary[PhotoNames.point.rawValue] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
    }

    private func toMapCoordinates() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
    }

    func toPhoto(with category: Category?) -> PhotoDVO {
        var photo = PhotoDVO(image: UIImage(), coordinate: toMapCoordinates())
        photo.id = id
        photo.category = category
        photo.date = date
        photo.description = description
        photo.imageUrls = images

        return photo
    }
}
