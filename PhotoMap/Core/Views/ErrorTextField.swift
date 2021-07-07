//
//  ErrorTextField.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 3.05.21.
//

import UIKit
import Combine

class ErrorTextField: ATCTextField {
    
    private let errorMessageLabel = UILabel()
    private let minTextLengthForShowError: Int = 2
    private(set) var errorSubject = PassthroughSubject<String?, Never>()
    private let cancelBag = CancelBag()
  
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupErrorLabel()
        bind()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupErrorLabel()
        bind()
    }
    
    private func setupErrorLabel() {
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

    private func bind() {
        errorSubject
            .sink { [weak self] error in
                guard let self = self else { return }
                guard let error = error,
                      let text = self.text,
                      text.count > self.minTextLengthForShowError else {
                    self.set(isHidden: true)
                    return
                }

                self.set(error, isHidden: false)
            }
            .store(in: cancelBag)
    }

    private func set(_ error: String? = nil, isHidden: Bool) {
        self.errorMessageLabel.text = error
        self.errorMessageLabel.isHidden = isHidden
    }
    
    // MARK: - deinit
    deinit {
        cancelBag.cancel()
    }
}
