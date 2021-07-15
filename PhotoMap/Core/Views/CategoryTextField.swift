//
//  CategoryTextField.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 7/15/21.
//

import UIKit
import Combine

@IBDesignable
class CategoryTextField: UITextField {
    private var imageView = UIImageView(image: UIImage(named: "circle.fill"))
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.style = .medium
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()

        return UIActivityIndicatorView()
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var categorySubject = PassthroughSubject<Category?, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        bind()
        leftView = loadingIndicator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        bind()
        leftView = loadingIndicator
    }
    
    private func set(_ category: Category) {
        loadingIndicator.stopAnimating()
        imageView.tintColor = UIColor(hex: category.color)
        leftView = imageView
        text = category.name
    }

    private func bind() {
        categorySubject
            .sink(receiveValue: { [weak self] category in
                    guard let category = category else { return }
                    self?.set(category)
            })
            .store(in: &cancellables)
    }
}
