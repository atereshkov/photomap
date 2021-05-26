//
//  Array+Ex.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 10.05.21.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        0 <= index && index < count ? self[index] : nil
    }
}
