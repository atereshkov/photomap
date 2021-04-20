//
//  UITextField+Ex.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/20/21.
//

import Foundation
import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func addRightView(txtField: UITextField, str: String) {
        let rightStr = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        rightStr.text = str + " "
        txtField.rightView = rightStr
        txtField.rightViewMode = .always
    }
}
