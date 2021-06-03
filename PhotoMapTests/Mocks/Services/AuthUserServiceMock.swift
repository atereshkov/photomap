//
//  AuthUserServiceMock.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 5.05.21.
//

import Combine
@testable import PhotoMap

class AuthUserServiceMock: AuthUserServiceType {
    
    var signInCalled = false
    var signInEmailParam: String?
    var signInPasswordParam: String?
    var signInError: ResponseError?
    
    var signUpCalled = false
    var signUpError: ResponseError?
    var signUpUsernameParam: String?
    var signUpEmailParam: String?
    var signUpPasswordParam: String?
    
    func signUp(email: String, password: String) -> Future<Void, Error> {
        signUpCalled = true
        return Future { [weak self] promise in
            if let error = self?.signUpError {
                promise(.failure(error))
            } else {
                promise(.success(()))
            }
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
