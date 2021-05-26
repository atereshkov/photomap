//
//  Photo.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 5/26/21.
//

import UIKit
import CoreLocation

struct Photo {
    var image: UIImage
    var date: Date = Date()
    var description: String = ""
    var category: Category?
    var hashTags: [String] = []
    var geopoint: CLLocationCoordinate2D?
}
