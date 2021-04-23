//
//  AuthListener.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import FirebaseAuth
import Combine

protocol AuthListenerType {
    func startListening()
}

class AuthListener: AuthListenerType {
    
    var isUserAuthoried: PassthroughSubject<Bool, Error>?
    
    func startListening() {
        Auth.auth().addStateDidChangeListener({ [weak self] _, user in
            if user != nil {
                self?.isUserAuthoried?.send(true)
            } else {
                self?.isUserAuthoried?.send(false)
            }
        })
    }
    
}
