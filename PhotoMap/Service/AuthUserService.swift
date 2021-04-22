//
//  UserService.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/22/21.
//

import Foundation
import Combine
import FirebaseAuth

protocol AuthUserServiceType {
    func signUp(email: String, password: String) -> Future<Void, Error>
    func signIn(email: String, password: String) -> Future<Void, Error>
    func logOut()
}

class AuthUserService: AuthUserServiceType {
    
    func signUp(email: String, password: String) -> Future<Void, Error> {
        return Future { resolve in
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                if let error = error {
                    resolve(.failure(error))
                } else {
                    resolve(.success(()))
                }
            }
        }
    }
    
    func signIn(email: String, password: String) -> Future<Void, Error> {
        return Future { resolve in
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let error = error {
                    resolve(.failure(error))
                } else {
                    resolve(.success(()))
                }
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            Swift.print(error.localizedDescription)
        }
    }
    
}
