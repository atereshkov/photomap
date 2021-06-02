//
//  CategoryViewModelType.swift
//  PhotoMap
//
//  Created by Yury Kasper on 1.06.21.
//

import Combine
import UIKit

protocol CategoryViewModelTypeInput {
    var doneButtonSubject: PassthroughSubject<Void, Never> { get }
    func didPressedButton(with: UIButton) 
}

protocol CategoryViewModelTypeOutput {}

protocol CategoryViewModelType: CategoryViewModelTypeInput, CategoryViewModelTypeOutput {}
