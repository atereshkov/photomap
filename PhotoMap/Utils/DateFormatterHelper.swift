//
//  DateFormatter.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import Foundation

class DateFormatterHelper {

    // MARK: - Shared

    static let shared = DateFormatterHelper()

    // MARK: - Formatters

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "y/MM/dd @ HH:mm"

        return dateFormatter
    }()
    
}
