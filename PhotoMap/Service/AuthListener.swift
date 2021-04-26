//
//  AuthListener.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import FirebaseAuth
import Combine

protocol AuthListenerType {
    var isUserAuthoried: CurrentValueSubject<Bool, Never> { get }
    func startListening()
}

class AuthListener: AuthListenerType {
    
    var isUserAuthoried = CurrentValueSubject<Bool, Never>(false)
    var handle: AuthStateDidChangeListenerHandle?
    
    func startListening() {
        handle = Auth.auth().addStateDidChangeListener({ [weak self] _, user in
            if user != nil {
                self?.isUserAuthoried.send(true)
            } else {
                self?.isUserAuthoried.send(false)
            }
        })
    }
    
}
