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
    var photoButtonSubject: PassthroughSubject<CLLocationCoordinate2D?, Never> { get }
    var loadUserPhotosSubject: PassthroughSubject<MKMapRect, FirestoreError> { get }
    var tapMapViewGestureSubject: PassthroughSubject<GestureType, Never> { get }
}

protocol MapViewModelOutput {
    var photos: [Photo] { get }
    var visiblePhotos: [Photo] { get }
    var filteredCategories: [Category] { get }
    var modeButtonTintColor: UIColor { get }
    var userTrackingMode: MKUserTrackingMode { get }
}

protocol MapViewModelType: MapViewModelInput, MapViewModelOutput {}
