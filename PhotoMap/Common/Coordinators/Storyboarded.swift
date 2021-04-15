//
//  Storyboarded.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: className, bundle: .main)
        guard let vc = storyboard.instantiateViewController(identifier: className) as? Self else {
            fatalError("Unknown View Controller!")
        }
        return vc
    }
}
