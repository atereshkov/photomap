//
//  UploadPhoto.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6/29/21.
//

import CoreLocation
import FirebaseFirestore

struct UploadPhoto {
    private(set) var imageData: Data?
    private(set) var imageName: String
    private(set) var dictionary: [String: Any]

    init(from photo: PhotoDVO) {
        imageData = photo.image?.pngData()
        imageName = photo.date.toString
        dictionary = [PhotoNames.category.rawValue: photo.category?.id ?? "",
                      PhotoNames.date.rawValue: Timestamp(date: photo.date),
                      PhotoNames.description.rawValue: photo.description,
                      PhotoNames.hashtags.rawValue: photo.hashtags,
                      PhotoNames.images.rawValue: [],
                      PhotoNames.point.rawValue: GeoPoint(latitude: photo.coordinate.latitude,
                                                          longitude: photo.coordinate.longitude)]
    }

    mutating func updateImageURLs(_ urls: [URL]) {
        dictionary.updateValue(urls.map { $0.absoluteString }, forKey: PhotoNames.images.rawValue)
    }
}
