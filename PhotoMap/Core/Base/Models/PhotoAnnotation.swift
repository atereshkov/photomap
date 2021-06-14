//
//  PhotoAnnotation.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6/10/21.
//

import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    private let photo: Photo
    var id: String { photo.id }
    var title: String? {
        photo.description == "" ? " " : photo.description
    }
    var date: Date { photo.date }
    var category: Category? { photo.category }
    var coordinate: CLLocationCoordinate2D { photo.coordinate }
    var imageUrl: String? {
        photo.imageUrls[safe: 0]
    }

    init(photo: Photo) {
        self.photo = photo

        super.init()
    }

    var subtitle: String? {
        date.shortDateWithFullYear
    }
}
