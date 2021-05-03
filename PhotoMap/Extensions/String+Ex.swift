//
//  String+Ex.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation

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
    
    var isEmptStr: Bool {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
    
}
