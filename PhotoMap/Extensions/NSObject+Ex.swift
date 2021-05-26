//
//  NSObject+Ex.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 10.05.21.
//

import Foundation

extension NSObject {
    var className: String {
        String(describing: type(of: self))
    }

    class var className: String {
        String(describing: self)
    }
}
