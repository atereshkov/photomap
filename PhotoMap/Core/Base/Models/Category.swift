//
//  Category.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import Foundation

struct Category: Codable {
    let id: String
    let name: String
    let color: String
    var isSelected = true

    init(id: String, name: String, color: String) {
        self.id = id
        self.name = name
        self.color = color
    }
}

extension Category {
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        name = dictionary["name"] as? String ?? ""
        color = dictionary["color"] as? String ?? ""
    }
}
