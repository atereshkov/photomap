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
    var categoryButtonSubject: PassthroughSubject<UIControl, Never> { get }
    var enableDiscoveryModeSubject: PassthroughSubject<GestureType, Never> { get }
    var navigationButtonSubject: PassthroughSubject<UIControl, Never> { get }
    var photoButtonSubject: PassthroughSubject<CLLocationCoordinate2D?, Never> { get }
}

protocol MapViewModelOutput {
    var isShowUserLocation: Bool { get }
    var region: MKCoordinateRegion? { get }
    var modeButtonCollor: UIColor { get }
    var isFollowModeOn: Bool { get }
}

protocol MapViewModelType: MapViewModelInput, MapViewModelOutput {}
