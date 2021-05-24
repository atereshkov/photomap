//
//  TimelineViewModelType.swift
//  PhotoMap
//
//  Created by yurykasper on 20.05.21.
//

import UIKit
import Combine

protocol TimelineViewModelTypeInput {}

protocol TimelineViewModelTypeOutput {
    var numberOfSections: Int { get }
    var numberOfRows: Int { get }
    func getMarker(at indexPath: IndexPath) -> Marker?
    func getTitle(for: Int) -> String?
}

protocol TimelineViewModelType: TimelineViewModelTypeInput, TimelineViewModelTypeOutput {}
