//
//  UIControl+Ex.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 4/23/21.
//

import UIKit
import Combine

protocol CombineCompatible { }

final class UIControlSubscription<SubscriberType: Subscriber,
                                  Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control
    private let event: UIControl.Event

    var currentDemand: Subscribers.Demand = .none

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.event = event
        control.addTarget(self, action: #selector(eventRaised), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        currentDemand += demand
    }

    func cancel() {
        subscriber = nil
        control.removeTarget(self, action: #selector(eventRaised), for: event)
    }

    @objc private func eventRaised() {
        if currentDemand > 0 {
            currentDemand += subscriber?.receive(control) ?? .none
            currentDemand -= 1
        }
    }
}

struct UIControlPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }
    
    func receive<S>(subscriber: S) where S: Subscriber,
                                         S.Failure == Self.Failure,
                                         S.Input == Self.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

extension UIControl: CombineCompatible { }

extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<UIControl> {
        return UIControlPublisher(control: self, events: events)
    }
}
