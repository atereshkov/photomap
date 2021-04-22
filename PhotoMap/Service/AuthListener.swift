//
//  AuthListener.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import Foundation
import FirebaseAuth

protocol AuthListenerType {
    func isUserAuthorized(completionHandler: @escaping (_ success: Bool) -> Void)
}

class AuthListener: AuthListenerType {
    
    func isUserAuthorized(completionHandler: @escaping (_ success: Bool) -> Void) {
        Auth.auth().addStateDidChangeListener({ _, user in
            if user != nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
    }
    
}
