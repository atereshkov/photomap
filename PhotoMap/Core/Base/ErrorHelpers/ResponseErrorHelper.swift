//
//  ResponseErrorHelper.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation

enum ResponseErrorHelper: ErrorHelper {
    case incorrectCredentials
    case networtConnection
    case registrationError
    case userAlreadyExists
    case other(message: String)

    var title: String {
        "Error".localized
    }

    var message: String {
        switch self {
        case .incorrectCredentials:
            return "Incorrect login or password".localized
        case .networtConnection:
            return "No network connection".localized
        case .registrationError:
            return "Registration error. Please try again.".localized
        case .userAlreadyExists:
            return """
                User with that email already exists. \
                If it's you, please, sign in or try again with a different email.
                """.localized
        case .other(let message):
            return message.localized
        }
    }
}
