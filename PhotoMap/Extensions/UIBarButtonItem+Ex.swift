//
//  UIBarButtonItem+Ex.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 7.05.21.
//

import UIKit
import Combine

// MARK: - UIBarButtonItem
final class UIBarButtonItemSubscription<SubscriberType: Subscriber>: Subscription
where SubscriberType.Input == UIBarButtonItem {
    private var subscriber: SubscriberType?
    private let control: UIBarButtonItem
    
    var currentDemand: Subscribers.Demand = .none
    
    init(subscriber: SubscriberType, control: UIBarButtonItem) {
        self.subscriber = subscriber
        self.control = control
        control.target = self
        control.action = #selector(eventHandler)
    }
    
    func request(_ demand: Subscribers.Demand) {
        currentDemand += demand
    }
    
    func cancel() {
        subscriber = nil
        control.action = nil
        control.target = nil
    }
    
    @objc private func eventHandler() {
        if currentDemand > 0 {
            currentDemand += subscriber?.receive(control) ?? .none
            currentDemand -= 1
        }
    }
}

struct UIBarButtonItemPublisher: Publisher {
    typealias Output = UIBarButtonItem
    typealias Failure = Never
    
    let control: UIBarButtonItem
    
    init(control: UIBarButtonItem) {
        self.control = control
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == UIBarButtonItemPublisher.Failure,
                                         S.Input == UIBarButtonItemPublisher.Output {
        let subscription = UIBarButtonItemSubscription(subscriber: subscriber, control: control)
        subscriber.receive(subscription: subscription)
    }
}

extension UIBarButtonItem {
    func publisher() -> UIBarButtonItemPublisher {
        return UIBarButtonItemPublisher(control: self)
    }
}
