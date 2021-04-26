// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// Close
  internal static let close = L10n.tr("Localizable", "close")
  /// Error
  internal static let error = L10n.tr("Localizable", "error")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok")

  internal enum InternetError {
    internal enum ErrorAlert {
      internal enum Button {
        /// Please, try again later
        internal static let ok = L10n.tr("Localizable", "internet-error.error-alert.button.ok")
      }
      internal enum Title {
        /// No network connection
        internal static let noNetworkConnection = L10n.tr("Localizable", "internet-error.error-alert.title.no-network-connection")
      }
    }
  }

  internal enum Login {
    internal enum Button {
      internal enum Title {
        /// Sign In
        internal static let signIn = L10n.tr("Localizable", "login.button.title.sign-in")
        /// Sign Up
        internal static let signUp = L10n.tr("Localizable", "login.button.title.sign-up")
      }
    }
  }

  internal enum Logout {
    internal enum Button {
      internal enum Title {
        /// Logout
        internal static let logOut = L10n.tr("Localizable", "logout.button.title.log-out")
      }
    }
    internal enum LogoutAlert {
      /// Are you sure you want to logout?
      internal static let title = L10n.tr("Localizable", "logout.logout-alert.title")
    }
  }

  internal enum Main {
    internal enum NavBar {
      internal enum Category {
        /// Category
        internal static let title = L10n.tr("Localizable", "main.nav-bar.category.title")
      }
      internal enum Search {
        /// Search
        internal static let title = L10n.tr("Localizable", "main.nav-bar.search.title")
      }
    }
    internal enum TabBar {
      internal enum Map {
        /// Map
        internal static let title = L10n.tr("Localizable", "main.tab-bar.map.title")
      }
      internal enum More {
        /// More
        internal static let title = L10n.tr("Localizable", "main.tab-bar.more.title")
      }
      internal enum Timeline {
        /// Timeline
        internal static let title = L10n.tr("Localizable", "main.tab-bar.timeline.title")
      }
    }
  }

  internal enum Profile {
    internal enum LogoutAlert {
      internal enum Button {
        /// Conform logout
        internal static let title = L10n.tr("Localizable", "profile.logout-alert.button.title")
      }
    }
  }

  internal enum SignUp {
    internal enum ErrorAlert {
      internal enum Title {
        /// Incorrect login or password
        internal static let incorrectPassword = L10n.tr("Localizable", "sign-up.error-alert.title.incorrect-password")
        /// Registration error. Please try again.
        internal static let registrationError = L10n.tr("Localizable", "sign-up.error-alert.title.registration-error")
        /// User with that email already exists.
        internal static let userAlreadyExists = L10n.tr("Localizable", "sign-up.error-alert.title.user-already-exists")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
