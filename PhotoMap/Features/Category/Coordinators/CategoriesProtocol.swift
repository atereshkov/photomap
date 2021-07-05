//
//  CategoriesProtocol.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 7/5/21.
//

import Foundation
import Combine

protocol CategoriesProtocol {
    var doneButtonPressedWithCategoriesSubject: PassthroughSubject<[Category], Never> { get }
}
