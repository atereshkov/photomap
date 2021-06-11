//
//  Photo.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 5/26/21.
//

import UIKit
import CoreLocation
import FirebaseFirestore

fileprivate enum Name: String {
    case category, date, description, hashtags, images, point
}

struct Photo {
    var image: UIImage
    var date: Date = Date()
    var description: String = ""
    var category: Category?
    var hashTags: [String] { description.findHashtags }
    var coordinate: CLLocationCoordinate2D

    func toDictionary(urls: [URL]) -> [String: Any] {
        guard let categoryId = category?.id else { return [:] }
        let urlsList = urls.map { $0.absoluteString }

        return [Name.category.rawValue: categoryId,
                Name.date.rawValue: Timestamp(date: date),
                Name.description.rawValue: description,
                Name.hashtags.rawValue: hashTags,
                Name.images.rawValue: urlsList,
                Name.point.rawValue: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)]
    }
}

struct ReceivePhoto {
    var images: [String]
    var date: Date = Date()
    var description: String = ""
    var category: String
    var geopoint: GeoPoint

    init(dictionary: [String: Any]) {
        category = dictionary[Name.category.rawValue] as? String ?? ""
        let timestamp = dictionary[Name.date.rawValue] as? Timestamp ?? Timestamp(date: Date())
        date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        description = dictionary[Name.description.rawValue] as? String ?? ""
        images = dictionary[Name.images.rawValue] as? [String] ?? []
        geopoint = dictionary[Name.point.rawValue] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
    }

    func toMapCoordinates() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
    }

    func toPhoto(with category: Category?) -> Photo {
        var photo = Photo(image: UIImage(), coordinate: toMapCoordinates())
        photo.category = category
        photo.date = date
        photo.description = description

        return photo
    }
}
