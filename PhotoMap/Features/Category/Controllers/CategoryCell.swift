//
//  CategoryCell.swift
//  PhotoMap
//
//  Created by Yury Kasper on 2.06.21.
//

import UIKit

final class CategoryCell: UITableViewCell {
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var categoryName: UILabel!
    
    func configure(with category: Category) {
        categoryName.text = category.name
        categoryName.textColor = UIColor(hex: category.color)
        selectButton.tintColor = UIColor(hex: category.color)
        // swiftlint:disable line_length
        category.isSelected ? selectButton.setImage(UIImage(systemName: "circle.fill"), for: .normal) : selectButton.setImage(UIImage(systemName: "circle"), for: .normal)
        // swiftlint:enable line_length
    }
}
