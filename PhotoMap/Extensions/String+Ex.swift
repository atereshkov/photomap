//
//  String+Ex.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit

extension String {
    
    var toPrettyDateString: String {
        let dateFormatter = CachedDateFormatter.with(format: self)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: self) else { return "No date" }
        
        return date.toString
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return testEmail.evaluate(with: self)
    }
    
    var toMonthAndYearDate: Date {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("LLLL yyyy")
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale.current
        
        return formatter.date(from: self) ?? Date()
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    var findHashtags: [String] {
        var hashtags: [String] = []
        let regex = try? NSRegularExpression(pattern: "(#[a-zA-Z0-9_\\p{Cyrillic}\\p{N}]*)", options: [])
        // swiftlint:disable legacy_constructor
        if let matches = regex?.matches(in: self, options: [], range: NSMakeRange(0, self.count)) {
            for match in matches {
                hashtags
                    .append(NSString(string: self)
                    .substring(with: NSRange(location: match.range.location, length: match.range.length)))
            }
        }
        // swiftlint:enable legacy_constructor

        return hashtags
    }
    
    func drawForCluster(in rect: CGRect) {
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        let textSize = self.size(withAttributes: attributes)
        let textRect = CGRect(x: (rect.width / 2) - (textSize.width / 2),
                              y: (rect.height / 2) - (textSize.height / 2),
                              width: textSize.width,
                              height: textSize.height)
        
        self.draw(in: textRect, withAttributes: attributes)
    }
}
