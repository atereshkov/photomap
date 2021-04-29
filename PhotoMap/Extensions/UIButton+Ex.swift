//
//  UIButton+Ex.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/29/21.
//

import UIKit

extension UIButton {
    var tapPublisher: UIControlPublisher<UIControl> {
        publisher(for: .touchUpInside)
    }
}
