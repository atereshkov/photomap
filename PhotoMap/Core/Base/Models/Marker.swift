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
    let photoURLString: String
    let location: (x: Int, y: Int)?
}

extension Marker {
    init(dictionary: [String: Any]) {
        category = dictionary["category"] as? String ?? ""
        let timestamp = dictionary["date"] as? Timestamp ?? Timestamp(date: Date())
        date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        description = dictionary["description"] as? String
        hashtags = dictionary["hashtags"] as? [String] ?? [String]()
        photoURLString = dictionary["photoURL"] as? String ?? ""
        location = dictionary["point"] as? (x: Int, y: Int)
    }
}