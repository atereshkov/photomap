//
//  SignInViewModelType.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/28/21.
//

import Combine

protocol SignInViewModelInput {
    var email: String { get set }
    var password: String { get set }
    
    var signUpButtonPublisher: Void { get set }
    var signInButtonPublisher: Void { get set }
}

protocol SignInViewModelOutput {
    var emailError: String? { get set }
    var passwordError: String? { get set }
    
    var isAuthEnabled: Bool { get set }
}

protocol SignInViewModelType: SignInViewModelInput, SignInViewModelOutput {
    
}
