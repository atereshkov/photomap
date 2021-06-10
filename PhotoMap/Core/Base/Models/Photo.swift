//
//  Photo.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 5/26/21.
//

import UIKit
import CoreLocation
import FirebaseFirestore

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

extension Photo {
    private enum Name: String {
        case category, date, description, hashtags, images, point
    }
}
