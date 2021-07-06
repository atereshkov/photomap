//
//  DependencyInjection.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import Swinject

protocol DIContainerType {
    func resolve<T>() -> T
}

class DIContainer: DIContainerType {
    
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

        container.register(LocationServiceType.self) { _ -> LocationServiceType in
            return LocationService()
        }.inObjectScope(.container)
        
        container.register(FileManagerServiceType.self) { _ -> FileManagerServiceType in
            return FileManagerService(fileManager: FileManager.default)
        }.inObjectScope(.container)
        
        container.register(FirestoreServiceType.self) { resolver in
            guard let fileManagerService = resolver.resolve(FileManagerServiceType.self) else {
                fatalError("File Manager Service does not exist")
            }
            return FirestoreService(fileManagerService: fileManagerService)
        }.inObjectScope(.container)
        
        container.register(ValidationServiceType.self) { _ -> ValidationServiceType in
            return ValidationService(emailValidator: EmailValidator(),
                                     passwordValidator: PasswordValidator(),
                                     usernameValidator: UsernameValidator())
        }.inObjectScope(.container)
    }
    
    func resolve<T>() -> T {
        guard let service = container.resolve(T.self) else {
            fatalError("Container failed to resolve a service of type \(T.self)")
        }
        return service
    }
}
