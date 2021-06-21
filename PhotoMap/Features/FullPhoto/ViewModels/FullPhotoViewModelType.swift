//
//  FullPhotoViewModelType.swift
//  PhotoMap
//
//  Created by yurykasper on 21.06.21.
//

import Combine
import UIKit

protocol FullPhotoViewModelTypeInput {
    var viewDidDisappear: PassthroughSubject<Void, Never> { get }
    var imageTappedSubject: PassthroughSubject<GestureType, Never> { get }
    var imageDoubleTappedSubject: PassthroughSubject<GestureType, Never> { get }
}

protocol FullPhotoViewModelTypeOutput {
    var image: UIImage? { get }
    var description: String? { get }
    var date: String? { get }
    var showFooterView: Bool { get }
    var showNavbar: Bool { get }
}

protocol FullPhotoViewModelType: FullPhotoViewModelTypeInput, FullPhotoViewModelTypeOutput {}
