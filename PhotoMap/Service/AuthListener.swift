//
//  AuthListener.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import FirebaseAuth
import Combine

protocol AuthListenerType {
    var isUserAuthoried: PassthroughSubject<Bool, Never> { get }
    func startListening()
}

class AuthListener: AuthListenerType {
    
    var isUserAuthoried = PassthroughSubject<Bool, Never>()
    
    func startListening() {
        Auth.auth().addStateDidChangeListener({ [weak self] _, user in
            if user != nil {
                self?.isUserAuthoried.send(true)
            } else {
                self?.isUserAuthoried.send(false)
            }
        })
    }
    
}
