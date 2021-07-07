//
//  CategoryView.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import UIKit
import Combine

@IBDesignable
class CategoryView: UIView {
    private let cancelBag = CancelBag()

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    private(set) var categorySubject = PassthroughSubject<Category?, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        bind()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
        bind()
    }

    func set(with category: Category) {
        loadingIndicator.stopAnimating()
        image.tintColor = UIColor(hex: category.color)
        title.text = category.name
    }

    private func bind() {
        categorySubject
            .sink(receiveValue: { [weak self] category in
                guard let category = category else { return }
                self?.set(with: category)
            })
            .store(in: cancelBag)
    }

    private func commonInit() {
        let bundle = Bundle.init(for: CategoryView.self)
        if let viewsToAdd = bundle.loadNibNamed(self.className, owner: self, options: nil),
            let contentView = viewsToAdd.first as? UIView {
            self.addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
    }

    // MARK: - deinit
    deinit {
        cancelBag.cancel()
    }
}
