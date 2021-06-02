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

  internal enum Auth {
    internal enum ErrorAlert {
      internal enum Title {
        /// User with that email already exists.
        internal static let emailAlreadyInUse = L10n.tr("Localizable", "auth.error-alert.title.email-already-in-use")
        /// The password is invalid.
        internal static let incorrectPassword = L10n.tr("Localizable", "auth.error-alert.title.incorrect-password")
        /// Sign in error. Please try again.
        internal static let signInFailure = L10n.tr("Localizable", "auth.error-alert.title.sign-in-failure")
        /// There is no user with this email.
        internal static let userNotFound = L10n.tr("Localizable", "auth.error-alert.title.user-not-found")
      }
    }
  }

  internal enum EmailValidation {
    internal enum ErrorAlert {
      /// Email field can't be blank
      internal static let emptyEmail = L10n.tr("Localizable", "email-validation.error-alert.empty-email")
      /// Please enter a valid email
      internal static let invalidEmail = L10n.tr("Localizable", "email-validation.error-alert.invalid-email")
      /// Minimum of 3 characters required
      internal static let shortEmail = L10n.tr("Localizable", "email-validation.error-alert.short-email")
    }
  }

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
    internal enum Map {
      internal enum DisableLocationAlert {
        /// With the location service disabled, you will not be able to use all the functionality of the App. Please go to the settings by the button below and enable it.
        internal static let message = L10n.tr("Localizable", "main.map.disable-location-alert.message")
        /// Location disabled
        internal static let title = L10n.tr("Localizable", "main.map.disable-location-alert.title")
        internal enum Button {
          internal enum Title {
            /// Close
            internal static let close = L10n.tr("Localizable", "main.map.disable-location-alert.button.title.close")
            /// Settings
            internal static let settings = L10n.tr("Localizable", "main.map.disable-location-alert.button.title.settings")
          }
        }
      }
    }
    internal enum MapPhoto {
      internal enum Button {
        internal enum Title {
          /// Cancel
          internal static let cancel = L10n.tr("Localizable", "main.map-photo.button.title.cancel")
          /// Close
          internal static let close = L10n.tr("Localizable", "main.map-photo.button.title.close")
          /// Done
          internal static let done = L10n.tr("Localizable", "main.map-photo.button.title.done")
        }
      }
    }
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
    internal enum PhotoAlert {
      internal enum Button {
        internal enum Title {
          /// Cancel
          internal static let cancel = L10n.tr("Localizable", "main.photo-alert.button.title.cancel")
          /// Choose From Library
          internal static let chooseFromLibrary = L10n.tr("Localizable", "main.photo-alert.button.title.chooseFromLibrary")
          /// Take a Picture
          internal static let takePicture = L10n.tr("Localizable", "main.photo-alert.button.title.takePicture")
        }
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

  internal enum PasswordValidation {
    internal enum ErrorAlert {
      /// Password field can't be blank
      internal static let emptyPassword = L10n.tr("Localizable", "password-validation.error-alert.empty-password")
      /// Minimum of 6 characters required
      internal static let shortPassword = L10n.tr("Localizable", "password-validation.error-alert.short-password")
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

  internal enum UsernameValidation {
    internal enum ErrorAlert {
      /// Username field can't be blank
      internal static let emptyUsername = L10n.tr("Localizable", "username-validation.error-alert.empty-username")
      /// Minimum of 3 characters required
      internal static let shortUsername = L10n.tr("Localizable", "username-validation.error-alert.short-username")
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
