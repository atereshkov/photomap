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
    
    func signInButtonTapped()
}

protocol SignInViewModelOutput {
    var validatedEmail: PassthroughSubject<Bool, EmailValidationError> { get set }
    var validatedPassword: PassthroughSubject<Bool, PasswordValidationError> { get set }
    
    var isAuthEnabled: PassthroughSubject<Bool, Error> { get set }
}

protocol SignInViewModelType: SignInViewModelInput, SignInViewModelOutput {
    
}
