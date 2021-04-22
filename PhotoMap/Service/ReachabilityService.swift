//
//  ReachabilityService.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/21/21.
//

import Foundation
import Reachability
import Combine

protocol ReachabilityServiceType: class {
    
    var reachability: Reachability! { get }
    
    func startNotifier()
    func stopNotifier()
    func checkNetworkConnection() -> AnyPublisher<Bool, Never>
    
}

class ReachabilityService: ReachabilityServiceType {
    
    var reachability: Reachability! = try? Reachability()
    
    func stopNotifier() {
       reachability.stopNotifier()
    }
    
    func checkNetworkConnection() -> AnyPublisher<Bool, Never> {
        return Reachability.isReachable
    }
    
    func startNotifier() {
       try? reachability.startNotifier()
    }
    
}
