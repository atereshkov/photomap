//
//  AuthListenerMock.swift
//  PhotoMapTests
//
//  Created by nb-058-41b on 5/10/21.
//

import Foundation
import Combine
@testable import PhotoMap

class AuthListenerMock: AuthListenerType {
    
    var isUserAuthorized = PassthroughSubject<Bool, Never>()
    
    func startListening() {
        
    }
    
    func checkUserAuthStatus() -> Bool {
        return false
    }
    
}
