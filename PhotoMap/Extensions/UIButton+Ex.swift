//
//  UIButton+Ex.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 4/23/21.
//

import UIKit

extension UIButton {
    var tapPublisher: EventPublisher {
        publisher(for: .touchUpInside)
    }
}
