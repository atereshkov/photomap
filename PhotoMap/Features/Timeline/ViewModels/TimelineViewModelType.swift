//
//  TimelineViewModelType.swift
//  PhotoMap
//
//  Created by yurykasper on 20.05.21.
//

import UIKit
import Combine

protocol TimelineViewModelTypeInput {
    
}

protocol TimelineViewModelTypeOutput {
    var numberOfSections: Int { get }
    var headerTitles: [String] { get }
    var numberOfRows: Int { get }
}

protocol TimelineViewModelType: TimelineViewModelTypeInput, TimelineViewModelTypeOutput {}
