//
//  DIContainerMock.swift
//  PhotoMapTests
//
//  Created by nb-058-41b on 5/10/21.
//

import Swinject
import Foundation
@testable import PhotoMap

class DIContainerMock: DIContainerType {
    
    let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func resolve<T>() -> T {
        guard let service = container.resolve(T.self) else {
            fatalError("Container failed to resolve a service of type \(T.self)")
        }
        return service
    }
    
}
