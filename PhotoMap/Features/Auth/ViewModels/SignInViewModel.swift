//
//  SignInViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import FirebaseAuth
import Combine

protocol SignInViewModelType: class {
    var authService: FirebaseAuthRepository { get }
    func signIn(with email: String, password: String) -> AnyPublisher<User, Error>
}

class SignInViewModel {
    
    @Published var email = ""
    @Published var password = ""
    
    let emailMessagePublisher = PassthroughSubject<String, Never>()
    let passwordMessagePublisher = PassthroughSubject<String, Never>()
    
    var validatedEmail: AnyPublisher<String?, Never> {
        
        return $email
            .map { email in
                
                guard email.isEmpty else {
                    
                    self.emailMessagePublisher.send("Email can't be blank")
                    return nil
                }
                
                guard email.count > 2 else {
                    
                    self.emailMessagePublisher.send("Minimum of 3 characters required")
                    return nil
                }
                
                guard email.isEmail else {
                    
                    self.emailMessagePublisher.send("Please enter a valid email")
                    return nil
                }
                
                self.emailMessagePublisher.send("")
                return email
        }
        .eraseToAnyPublisher()
    }
    
    var validatedPassword: AnyPublisher<String?, Never> {
        
        return $password
            .map { password in
                
                guard password.count > 4 else {
                    
                    self.emailMessagePublisher.send("Minimum of 4 characters required")
                    return nil
                }
                
                self.passwordMessagePublisher.send("")
                return password
        }
        .eraseToAnyPublisher()
    }
    
    var readyToSubmit: AnyPublisher<(String, String)?, Never> {
        
        return Publishers.CombineLatest(validatedEmail, validatedPassword)
            .map { email, password in
                
                guard let email = email, let password = password else {
                    return nil
                }
                return (email, password)
        }
        .eraseToAnyPublisher()
    }
}
