//
//  ErrorTextField.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 3.05.21.
//

import UIKit

class ErrorTextField: ATCTextField {
    
    private let errorMessageLabel = UILabel()
  
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupErrorLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupErrorLabel()
    }
    
    func setupErrorLabel() {
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = .red
        errorMessageLabel.font = UIFont.italicSystemFont(ofSize: 11)
        errorMessageLabel.isHidden = true
        self.addSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bottomAnchor.constraint(equalTo: errorMessageLabel.topAnchor, constant: 0)
        ])
    }
    
    func showError(_ error: String) {
        self.errorMessageLabel.text = error
        self.errorMessageLabel.isHidden = false
    }
    
    func hideError() {
        self.errorMessageLabel.isHidden = true
    }
    
}
