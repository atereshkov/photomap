//
//  AuthUserServiceMock.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 5.05.21.
//

import FirebaseAuth
import Combine

class MockAuthUserService: AuthUserServiceType {
    
    func signUp(email: String, password: String) -> Future<Void, Error> {
        return Future { promise in
            promise(.success(()))
        }
    }
    
    func signIn(email: String, password: String) -> Future<Void, Error> {
        return Future { promise in
            promise(.success(()))
        }
    }
    
    func logOut() {}
    
}
