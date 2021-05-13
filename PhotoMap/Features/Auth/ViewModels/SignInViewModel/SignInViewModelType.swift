//
//  SignInViewModelType.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/28/21.
//

import Combine
import UIKit

protocol SignInViewModelInput {
    var email: String { get set }
    var password: String { get set }
    
    var signUpButtonSubject: PassthroughSubject<UIControl, Never> { get }
    var signInButtonSubject: PassthroughSubject<UIControl, Never> { get }
}

protocol SignInViewModelOutput {
    var emailError: String? { get set }
    var passwordError: String? { get set }
    
    var isAuthEnabled: Bool { get set }
    var showLoadingIndicator: CurrentValueSubject<Bool, Never> { get set }
}

protocol SignInViewModelType: SignInViewModelInput, SignInViewModelOutput {
    
}
