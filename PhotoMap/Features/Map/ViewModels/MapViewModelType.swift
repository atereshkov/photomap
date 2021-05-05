//
//  MapViewModelType.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 4/27/21.
//

import Foundation
import MapKit
import Combine

protocol MapViewModelInput {
    var categoryButtonSubject: PassthroughSubject<Void, Never> { get set }
    var enableDiscoveryModeSubject: PassthroughSubject<Void, Never> { get set }
    var navigationButtonSubject: PassthroughSubject<Void, Never> { get set }
    var photoButtonSubject: PassthroughSubject<Void, Never> { get set }
}

protocol MapViewModelOutput {
    var tabTitle: String { get }
    var isShowUserLocation: Bool { get }
    var region: MKCoordinateRegion? { get }
    var modeButtonCollor: UIColor { get }
}

protocol MapViewModelType: MapViewModelInput, MapViewModelOutput {}
