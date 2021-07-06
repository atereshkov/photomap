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
}

extension User {
    init(snapshotData: [String: Any]) {
        name = snapshotData["name"] as? String ?? ""
        email = snapshotData["email"] as? String ?? ""
    }
}
