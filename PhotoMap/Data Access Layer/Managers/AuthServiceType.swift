//
//  AuthServiceType.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/20/21.
//

import Foundation
import Combine

protocol AuthServiceType {
    
    func createUser(email: String, password: String) -> Future<Void, Error>
    
    func signIn(email: String, password: String) -> Future<Void, Error>
    
    func logout()
}
