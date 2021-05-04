//
//  MapViewModelType.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 4/27/21.
//
import Foundation
import MapKit

protocol MapViewModelInput {
    var categoryButtonPublisher: Void { get set }
    var enableDiscoveryModePublisher: Void { get set }
    var navigationButtonPublisher: Void { get set }
    var photoButtonPublisher: Void { get set }
}

protocol MapViewModelOutput {
    var tabTitle: String { get }
    var isShowUserLocation: Bool { get }
    var region: MKCoordinateRegion? { get }
    var modeButtonCollor: UIColor { get }
}

protocol MapViewModelType: MapViewModelInput, MapViewModelOutput {}
