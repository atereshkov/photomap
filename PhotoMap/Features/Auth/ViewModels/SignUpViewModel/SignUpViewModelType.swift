//
//  SignUpViewModelType.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/28/21.
//

import Combine
import UIKit

protocol SignUpViewModelInput {
    var username: String { get set }
    var email: String { get set }
    var password: String { get set }

    var signUpButtonSubject: PassthroughSubject<UIControl, Never> { get }
}

protocol SignUpViewModelOutput {
    var usernameError: String? { get set }
    var emailError: String? { get set }
    var passwordError: String? { get set }
    
    var isRegistrationEnabled: Bool { get set }
}

protocol SignUpViewModelType: SignUpViewModelInput, SignUpViewModelOutput {
    
}