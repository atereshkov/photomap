//
//  Marker.swift
//  PhotoMap
//
//  Created by yurykasper on 24.05.21.
//

import Foundation
import FirebaseFirestore

struct Marker {
    let category: String
    let date: Date
    var description: String?
    var hashtags = [String]()
    let images: [String]
    let location: GeoPoint?
}

extension Marker {
    var localImageURL: URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let imageLink = images.first else { return nil }
        let fileName = "\(imageLink).png"
        return documentDirectory?.appendingPathComponent(fileName)
    }
    
    init(dictionary: [String: Any]) {
        category = dictionary["category"] as? String ?? ""
        let timestamp = dictionary["date"] as? Timestamp ?? Timestamp(date: Date())
        date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        description = dictionary["description"] as? String
        hashtags = dictionary["hashtags"] as? [String] ?? [String]()
        images = dictionary["images"] as? [String] ?? [String]()
        location = dictionary["point"] as? GeoPoint
    }
}
