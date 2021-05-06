//
//  CategoryView.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import UIKit

@IBDesignable
class CategoryView: UIView {
    private let selfName = "CategoryView"

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var title: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    func set(with category: Category) {
        image.tintColor = UIColor(hex: category.color)
        title.text = category.name
    }

    private func commonInit() {
        let bundle = Bundle.init(for: CategoryView.self)
        if let viewsToAdd = bundle.loadNibNamed(self.selfName, owner: self, options: nil),
            let contentView = viewsToAdd.first as? UIView {
            self.addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
}
