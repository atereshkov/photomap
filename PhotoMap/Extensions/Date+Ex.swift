//
//  Date+Ex.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation

extension Date {
    var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY HH:mm"

        return formatter.string(from: self)
    }
}
