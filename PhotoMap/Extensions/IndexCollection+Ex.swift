//
//  IndexCollection+Ex.swift
//  PhotoMap
//
//  Created by yurykasper on 24.05.21.
//

import Foundation

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    public subscript(at index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}
