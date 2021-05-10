//
//  MapPhotoViewModelType.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 10.05.21.
//

import UIKit
import Combine

protocol MapPhotoViewModelInput {
    var cancelButtonSubject: PassthroughSubject<UIControl, Never> { get }
    var descriptionSubject: PassthroughSubject<String, Never> { get }
    var doneButtonSubject: PassthroughSubject<UIControl, Never> { get }
}

protocol MapPhotoViewModelOutput {
    var isHiddenCategoryPicker: Bool { get set }
    var categoryPublisher: Category? { get }
}

protocol MapPhotoViewModelType: MapPhotoViewModelInput, MapPhotoViewModelOutput {}
