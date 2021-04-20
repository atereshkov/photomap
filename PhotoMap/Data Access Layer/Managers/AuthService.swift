//
//  AuthService.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/20/21.
//

import FirebaseAuth
import Combine

class FirebaseAuthRepository: AuthServiceType {
    
    private var cancelBag = CancelBag()
    
    func createUser(email: String, password: String) -> Future<Void, Error> {
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
                    // handle AuthErrorCode, map to custom error
                    resolve(.failure(error))
                } else {
                    resolve(.success(()))
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            Swift.print(error.localizedDescription)
        }
    }
    
}
