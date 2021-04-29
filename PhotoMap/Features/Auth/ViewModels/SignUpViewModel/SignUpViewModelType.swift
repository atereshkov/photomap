//
//  SignUpViewModelType.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/28/21.
//

import Combine

protocol SignUpViewModelInput {
    var email: String { get set }
    var password: String { get set }
    
    func signUpButtonTapped()
}

protocol SignUpViewModelOutput {
    var emailError: String? { get set }
    var passwordError: String? { get set }
    
    var isRegistrationEnabled: Bool { get set }
}

protocol SignUpViewModelType: SignUpViewModelInput, SignUpViewModelOutput {
    
}
