//
//  Photo.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 5/26/21.
//

import UIKit
import CoreLocation
import FirebaseFirestore

struct PhotoDVO {
    var id: String = ""
    var image: UIImage?
    var imageUrls: [String] = []
    var date: Date = Date()
    var description: String = ""
    var category: Category?
    var hashTags: [String] { description.findHashtags }
    var coordinate: CLLocationCoordinate2D

    func toDictionary(urls: [URL]) -> [String: Any] {
        guard let categoryId = category?.id else { return [:] }
        let urlsList = urls.map { $0.absoluteString }

        return [PhotoNames.category.rawValue: categoryId,
                PhotoNames.date.rawValue: Timestamp(date: date),
                PhotoNames.description.rawValue: description,
                PhotoNames.hashtags.rawValue: hashTags,
                PhotoNames.images.rawValue: urlsList,
                PhotoNames.point.rawValue: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)]
    }
}
