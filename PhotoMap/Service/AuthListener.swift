//
//  AuthListener.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import FirebaseAuth
import Combine

protocol AuthListenerType {
    var isUserAuthorized: CurrentValueSubject<Bool, Never> { get }
    func startListening()
}

class AuthListener: AuthListenerType {
    
    var isUserAuthorized = CurrentValueSubject<Bool, Never>(false)
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
    
}
