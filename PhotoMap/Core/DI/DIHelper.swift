//
//  DependencyInjection.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import Swinject

protocol DIHelperType {
    func resolve<T>() -> T
}

class DIHelper: DIHelperType {
    
    private let container: Container = Container()
    
    init() {
        container.register(ReachabilityServiceType.self) { _ -> ReachabilityServiceType in
            return ReachabilityService()
        }.inObjectScope(.container)
        
        container.register(AuthListenerType.self) { _ -> AuthListenerType in
            return AuthListener()
        }.inObjectScope(.container)
        
        container.register(AuthUserServiceType.self) { _ -> AuthUserServiceType in
            return AuthUserService()
        }.inObjectScope(.container)
    }
    
    func resolve<T>() -> T {
        guard let service = container.resolve(T.self) else {
            fatalError("Container failed to resolve a service of type \(T.self)")
        }
        return service
    }
}
