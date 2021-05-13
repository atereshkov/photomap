//
//  AppCoordinatorType.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 12.05.21.
//

import Foundation

protocol AppCoordinatorType: Coordinator {
    func start()
    func showMap()
    func showAuth()
    func showInitial()
    func startMainScreen(isUserAuthorized: Bool)
}
