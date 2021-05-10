//
//  AuthUserServiceMock.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 5.05.21.
//

import FirebaseAuth
import Combine

class MockAuthUserService: AuthUserServiceType {
    
    var signInCalled = false
    var signInEmailParam: String?
    var signInPasswordParam: String?
    var signInError: Error?
    
    func signUp(email: String, password: String) -> Future<Void, Error> {
        return Future { promise in
            promise(.success(()))
        }
    }
    
    func signIn(email: String, password: String) -> Future<Void, Error> {
        signInCalled = true
        signInEmailParam = email
        signInPasswordParam = password
        
        return Future { [weak self] promise in
            if let error = self?.signInError {
                promise(.failure(error))
            } else {
                promise(.success(()))
            }
        }
    }
    
    func logOut() {}
    
}
