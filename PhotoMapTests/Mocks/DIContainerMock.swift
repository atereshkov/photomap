//
//  DIContainerMock.swift
//  PhotoMapTests
//
//  Created by nb-058-41b on 5/10/21.
//

import Swinject
@testable import PhotoMap

class DIContainerMock: DIContainerType {
    
    private let container: Container = Container()

    init() {
        container
            .register(ReachabilityServiceType.self) { _ -> ReachabilityServiceType in
                ReachabilityService()
            }.inObjectScope(.container)

        container
            .register(AuthListenerType.self) { _ -> AuthListenerType in
                AuthListenerMock()
            }.inObjectScope(.container)

        container
            .register(AuthUserServiceType.self) { _ -> AuthUserServiceType in
                AuthUserServiceMock()
            }.inObjectScope(.container)

        container
            .register(LocationServiceType.self) { _ -> LocationServiceType in
                LocationServiceMock()
            }.inObjectScope(.container)
        
        container
            .register(FirestoreServiceType.self) { _ -> FirestoreServiceType in
                FirestoreServiceMock()
            }.inObjectScope(.container)
        
        container.register(ValidationServiceType.self) { _ -> ValidationServiceType in
            return ValidationService(emailValidator: EmailValidator(),
                                         passwordValidator: PasswordValidator(),
                                         usernameValidator: UsernameValidator())
        }.inObjectScope(.container)
        
        container.register(FileManagerServiceType.self) { _ -> FileManagerServiceType in
            return FileManagerService(fileManager: FileManager.default)
        }.inObjectScope(.container)
    }
    
    func resolve<T>() -> T {
        guard let service = container.resolve(T.self) else {
            fatalError("Container failed to resolve a service of type \(T.self)")
        }
        return service
    }
    
}
