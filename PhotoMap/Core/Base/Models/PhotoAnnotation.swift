//
//  PhotoAnnotation.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6/10/21.
//

import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    private(set) var photo: PhotoDVO
    private let maxTitleCount: Int = 23
    private let substringCount: Int = 20

    var title: String? {
        var title = photo.description
        if title.count > maxTitleCount {
            title = "\(String(title.prefix(substringCount)))..."
        }

        return photo.description == "" ? " " : title
    }
    
    var subtitle: String? {
        photo.date.shortDateWithFullYear
    }

    var category: Category? { photo.category }
    var coordinate: CLLocationCoordinate2D { photo.coordinate }
    var imageUrl: String? {
        photo.imageUrls[safe: 0]
    }

    init(photo: PhotoDVO) {
        self.photo = photo

        super.init()
    }
}
