//
//  ChildCoordinator.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 7/5/21.
//

import Foundation
import Combine

protocol ChildCoordinator: Coordinator {
    var dismissSubject: PassthroughSubject<Void, Never> { get }
}
