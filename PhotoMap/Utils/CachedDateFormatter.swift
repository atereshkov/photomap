//
//  DateFormatter.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import Foundation

class CachedDateFormatter {

    // MARK: - Shared

    private(set) static var cache: [String: DateFormatter] = [:]
    
    // MARK: - Formatters

    static func with(format: String) -> DateFormatter {
        if let formatter = cache[format] {
            return formatter
        }
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(format)
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale.current
        cache[format] = formatter
        return formatter
    }
    
}
