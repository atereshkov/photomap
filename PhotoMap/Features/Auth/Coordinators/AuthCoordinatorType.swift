//
//  AuthCoordinatorType.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 12.05.21.
//

import UIKit
import Combine

protocol AuthCoordinatorType: Coordinator {
    var showErrorAlertSubject: PassthroughSubject<ResponseError, Never> { get }
    var showMapSubject: PassthroughSubject<Void, Never> { get }
    var showSignUpSubject: PassthroughSubject<Void, Never> { get }

    func start() -> UIViewController
}
