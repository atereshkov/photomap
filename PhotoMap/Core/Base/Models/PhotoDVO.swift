//
//  Photo.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 5/26/21.
//

import UIKit
import CoreLocation

struct PhotoDVO {
    var id: String = ""
    var image: UIImage?
    var imageUrls: [String] = []
    var date: Date = Date()
    var description: String = ""
    var category: Category?
    var hashtags: [String] { description.findHashtags }
    var coordinate: CLLocationCoordinate2D

}
