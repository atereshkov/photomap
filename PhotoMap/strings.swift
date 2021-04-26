// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Вы действительно хотите выйти?
  internal static let areYouSureYouWantToLogout = L10n.tr("Localizable", "Are you sure you want to logout?")
  /// Отмена
  internal static let cancel = L10n.tr("Localizable", "Cancel")
  /// Закрыть
  internal static let close = L10n.tr("Localizable", "Close")
  /// Подтвердите выход
  internal static let conformLogout = L10n.tr("Localizable", "Conform logout")
  /// Ошибка
  internal static let error = L10n.tr("Localizable", "Error")
  /// Неверный логин или пароль
  internal static let incorrectLoginOrPassword = L10n.tr("Localizable", "Incorrect login or password")
  /// Выйти
  internal static let logout = L10n.tr("Localizable", "Logout")
  /// Отсутствует интернет соединение
  internal static let noNetworkConnection = L10n.tr("Localizable", "No network connection")
  /// ОК
  internal static let ok = L10n.tr("Localizable", "OK")
  /// Пожалуйста, попробуйте позже
  internal static let pleaseTryAgainLater = L10n.tr("Localizable", "Please, try again later")
  /// Войти
  internal static let signIn = L10n.tr("Localizable", "Sign In")
  /// Регистрация
  internal static let signUp = L10n.tr("Localizable", "Sign Up")
  /// Аккаунт с такой почтой уже существует.
  internal static let userWithThatEmailAlreadyExists = L10n.tr("Localizable", "User with that email already exists.")

  internal enum RegistrationError {
    /// Ошибка регистрации. Пожалуйста, попробуйте еще раз.
    internal static let pleaseTryAgain = L10n.tr("Localizable", "Registration error. Please try again.")
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
