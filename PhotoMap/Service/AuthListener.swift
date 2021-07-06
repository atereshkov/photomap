//
//  AuthListener.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import FirebaseAuth
import Combine

protocol AuthListenerType {
    func isAuthorized() -> Bool
}

class AuthListener: AuthListenerType {
    
    func isAuthorized() -> Bool {
        return Auth.auth().currentUser != nil ? true : false
    }
    
}
