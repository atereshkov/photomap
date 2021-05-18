//
//  AuthCoordinatorType.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 12.05.21.
//

import UIKit

protocol AuthCoordinatorType: Coordinator {
    func start() -> UIViewController
    func openSignUpScreen()
    func showErrorAlert(error: ResponseError)
    func showMap()
    func closeScreen()
}
