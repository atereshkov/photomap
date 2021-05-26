//
//  Date+Ex.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation

extension Date {
    
    var toString: String {
        let dateString = CachedDateFormatter.with(format: "MMMM d, YYYY").string(from: self)
        let timeString = CachedDateFormatter.with(format: "h:mm a").string(from: self)

        return "\(dateString) - \(timeString)"
    }
    
    var monthAndYear: String {
        let formatter = CachedDateFormatter.with(format: "LLLL yyyy")
        return formatter.string(from: self)
    }
    
    var shortDate: String {
        let formatter = CachedDateFormatter.with(format: "dd.MM.yy")
        return formatter.string(from: self).split(separator: "/").joined(separator: "-")
    }
    
}
