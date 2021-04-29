//
//  MapViewModelType.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 4/27/21.
//

import Foundation
import MapKit

protocol MapViewModelInput {
    func switchFollowDiscoveryMode()
}

protocol MapViewModelOutput {
    var tabTitle: String { get }
    var isShowUserLocation: Bool { get }
    var region: MKCoordinateRegion? { get }
    var modeButtonCollor: UIColor { get }
}

protocol MapViewModelType: MapViewModelInput, MapViewModelOutput {}