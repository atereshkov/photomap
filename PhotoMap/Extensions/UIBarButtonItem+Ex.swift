//
//  UIBarButtonItem+Ex.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 7.05.21.
//

import UIKit
import Combine

// MARK: - UIBarButtonItem
public extension UIBarButtonItem {
    final class Subscription<SubscriberType: Subscriber,
                             Input: UIBarButtonItem>: Combine.Subscription where SubscriberType.Input == Input {
        private var subscriber: SubscriberType?
        private let input: Input

        public init(subscriber: SubscriberType, input: Input) {
            self.subscriber = subscriber
            self.input = input
            input.target = self
            input.action = #selector(eventHandler)
        }

        public func request(_ demand: Subscribers.Demand) {}

        public func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(input)
        }
    }

    struct Publisher<Output: UIBarButtonItem>: Combine.Publisher {
        public typealias Output = Output
        public typealias Failure = Never

        let output: Output

        public init(output: Output) {
            self.output = output
        }

        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, input: output)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension UIBarButtonItem: CombineCompatible {
    public convenience init(image: UIImage?,
                            style: UIBarButtonItem.Style,
                            cancellables: inout Set<AnyCancellable>,
                            action: @escaping () -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)
        self.publisher.sink { _ in action() }.store(in: &cancellables)
    }

    public convenience init(image: UIImage?,
                            landscapeImagePhone: UIImage?,
                            style: UIBarButtonItem.Style,
                            cancellables: inout Set<AnyCancellable>,
                            action: @escaping () -> Void) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        self.publisher.sink { _ in action() }.store(in: &cancellables)
    }

    public convenience init(title: String?,
                            style: UIBarButtonItem.Style,
                            cancellables: inout Set<AnyCancellable>,
                            action: @escaping () -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)
        self.publisher.sink { _ in action() }.store(in: &cancellables)
    }

    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem,
                            cancellables: inout Set<AnyCancellable>,
                            action: @escaping () -> Void) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        self.publisher.sink { _ in action() }.store(in: &cancellables)
    }
}

extension CombineCompatible where Self: UIBarButtonItem {
    var publisher: UIBarButtonItem.Publisher<UIBarButtonItem> {
        .init(output: self)
    }
}

// --------------------------------------------------------------------------------------------------------------
/*
final class UIBarButtonItemSubscription<SubscriberType: Subscriber>: Subscription
  where SubscriberType.Input == UIBarButtonItem {
  private var subscriber: SubscriberType?
  private let control: UIBarButtonItem

  init(subscriber: SubscriberType, control: UIBarButtonItem) {
    self.subscriber = subscriber
    self.control = control
    control.target = self
    control.action = #selector(self.eventHandler)
  }

  func request(_ demand: Subscribers.Demand) {
    // We do nothing here as we only want to send events when they occur.
    // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
  }

  func cancel() {
    self.subscriber = nil
  }

  @objc private func eventHandler() {
    _ = self.subscriber?.receive(self.control)
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
*/
