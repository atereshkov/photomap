//
//  TimelineViewModelType.swift
//  PhotoMap
//
//  Created by yurykasper on 20.05.21.
//

import UIKit
import Combine

protocol TimelineViewModelTypeInput {
    var categoryButtonSubject: PassthroughSubject<UIBarButtonItem, Never> { get }
    var searchTextSubject: CurrentValueSubject<String, Never> { get }
    func viewDidLoad()
}

protocol TimelineViewModelTypeOutput {
    var numberOfSections: Int { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var reloadDataSubject: PassthroughSubject<Void, Never> { get }
    func getMarker(at indexPath: IndexPath) -> Marker?
    func getTitle(for: Int) -> String?
    func getNumberOfRows(in section: Int) -> Int
}

protocol TimelineViewModelType: TimelineViewModelTypeInput, TimelineViewModelTypeOutput {}
