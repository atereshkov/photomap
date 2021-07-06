//
//  User.swift
//  PhotoMap
//
//  Created by yurykasper on 24.06.21.
//

import Foundation

struct User {
    let name: String
    let email: String
    
    var representation: [String: Any] {
        var dict = [String: Any]()
        dict[Properties.name.rawValue] = name
        dict[Properties.email.rawValue] = email
        return dict
    }
}

extension User {
    private enum Properties: String {
        case name
        case email
    }
    
    init(snapshotData: [String: Any]) {
        name = snapshotData["name"] as? String ?? ""
        email = snapshotData["email"] as? String ?? ""
    }
}
