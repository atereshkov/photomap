//
//  CategoryViewModelType.swift
//  PhotoMap
//
//  Created by Yury Kasper on 1.06.21.
//

import Combine
import UIKit

protocol CategoryViewModelTypeInput {
    var doneButtonSubject: PassthroughSubject<UIBarButtonItem, Never> { get }
    var viewDidLoadSubject: PassthroughSubject<Void, Never> { get }
    func didSelectRow(at: IndexPath)
}

protocol CategoryViewModelTypeOutput {
    var reloadDataSubject: PassthroughSubject<Void, Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    func getNumberOfRows() -> Int
    func getCategory(at: IndexPath) -> Category?
}

protocol CategoryViewModelType: CategoryViewModelTypeInput, CategoryViewModelTypeOutput {}
