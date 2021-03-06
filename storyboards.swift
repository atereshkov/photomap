// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Authentication: StoryboardType {
    internal static let storyboardName = "Authentication"

    internal static let signInViewController = SceneType<SignInViewController>(storyboard: Authentication.self, identifier: "SignInViewController")

    internal static let signUpViewController = SceneType<SignUpViewController>(storyboard: Authentication.self, identifier: "SignUpViewController")
  }
  internal enum Category: StoryboardType {
    internal static let storyboardName = "Category"

    internal static let categoryViewController = SceneType<CategoryViewController>(storyboard: Category.self, identifier: "CategoryViewController")
  }
  internal enum FullPhoto: StoryboardType {
    internal static let storyboardName = "FullPhoto"

    internal static let fullPhotoViewController = SceneType<FullPhotoViewController>(storyboard: FullPhoto.self, identifier: "FullPhotoViewController")
  }
  internal enum Initial: StoryboardType {
    internal static let storyboardName = "Initial"

    internal static let initialViewController = SceneType<InitialViewController>(storyboard: Initial.self, identifier: "InitialViewController")
  }
  internal enum Map: StoryboardType {
    internal static let storyboardName = "Map"

    internal static let mapViewController = SceneType<MapViewController>(storyboard: Map.self, identifier: "MapViewController")
  }
  internal enum MapPhoto: StoryboardType {
    internal static let storyboardName = "MapPhoto"

    internal static let mapPhotoViewController = SceneType<MapPhotoViewController>(storyboard: MapPhoto.self, identifier: "MapPhotoViewController")
  }
  internal enum Profile: StoryboardType {
    internal static let storyboardName = "Profile"

    internal static let profileViewController = SceneType<ProfileViewController>(storyboard: Profile.self, identifier: "ProfileViewController")
  }
  internal enum Timeline: StoryboardType {
    internal static let storyboardName = "Timeline"

    internal static let timelineViewController = SceneType<TimelineViewController>(storyboard: Timeline.self, identifier: "TimelineViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
