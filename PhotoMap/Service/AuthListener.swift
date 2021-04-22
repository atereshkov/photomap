//
//  AuthListener.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import Foundation
import FirebaseAuth

protocol AuthListenerType {
    func isUserAuthorized() -> Bool
}

class AuthListener: AuthListenerType {
    
    func isUserAuthorized() -> Bool {
        var isUserAuthorized = false
        
        Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                isUserAuthorized = true
            } else {
                isUserAuthorized = false
            }
        }
        
        return isUserAuthorized
    }
    
}
