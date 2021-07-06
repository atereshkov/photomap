//
//  MoreViewModelType.swift
//  PhotoMap
//
//  Created by yurykasper on 24.06.21.
//

import Combine
import UIKit

protocol ProfileViewModelTypeInput {
    var viewDidLoadSubject: PassthroughSubject<Void, Never> { get }
    var logoutButtonSubject: PassthroughSubject<UIBarButtonItem, Never> { get }
}

protocol ProfileViewModelTypeOutput {
    var username: String? { get }
    var email: String? { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
}

protocol ProfileViewModelType: ProfileViewModelTypeInput, ProfileViewModelTypeOutput {}
