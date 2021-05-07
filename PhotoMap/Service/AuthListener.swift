//
//  AuthListener.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import FirebaseAuth
import Combine

protocol AuthListenerType {
    var isUserAuthorized: PassthroughSubject<Bool, Never> { get }
    func startListening()
    func checkUserAuthStatus() -> Bool
}

class AuthListener: AuthListenerType {
    
    var isUserAuthorized = PassthroughSubject<Bool, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    func startListening() {
        handle = Auth.auth().addStateDidChangeListener({ [weak self] _, user in
            if user != nil {
                self?.isUserAuthorized.send(true)
            } else {
                self?.isUserAuthorized.send(false)
            }
        })
    }
    
    func checkUserAuthStatus() -> Bool {
        let isUserAuth = Auth.auth().currentUser != nil ? true : false
        return isUserAuth
    }
    
}
