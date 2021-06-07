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
    var categoryViewSubject: PassthroughSubject<GestureType, Never> { get }
    var closeBarButtonSubject: PassthroughSubject<UIBarButtonItem, Never> { get }
    var descriptionSubject: PassthroughSubject<String, Never> { get }
    var doneButtonSubject: PassthroughSubject<String, Never> { get }
    var loadCategoriesSubject: PassthroughSubject<Void, Never> { get }
}

protocol MapPhotoViewModelOutput {
    var isHiddenCategoryPicker: Bool { get }
    var categoryPublisher: Category? { get }
    var photoPublisher: Photo { get }
}

protocol MapPhotoViewModelType: MapPhotoViewModelInput, MapPhotoViewModelOutput {}
