//
//  ResponseError.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation
import FirebaseAuth

enum ResponseError: GeneralErrorType {
    case networkError, wrongPassword, userNotFound, emailAlreadyInUse, signInFailure, other(message: String)

    var title: String {
        L10n.error
    }

    var message: String {
        switch self {
        case .networkError:
            return L10n.InternetError.ErrorAlert.Title.noNetworkConnection
        case .wrongPassword:
            return L10n.Auth.ErrorAlert.Title.incorrectPassword
        case .userNotFound:
            return L10n.Auth.ErrorAlert.Title.userNotFound
        case .emailAlreadyInUse:
            return L10n.Auth.ErrorAlert.Title.emailAlreadyInUse
        case .signInFailure:
            return L10n.Auth.ErrorAlert.Title.signInFailure
        case .other(let message):
            return message
        }
    }

    init(_ error: Error) {
        let errorCode = AuthErrorCode(rawValue: error._code)

        switch errorCode {
        case .wrongPassword:
            self = .wrongPassword
        case .userNotFound:
            self = .userNotFound
        case .emailAlreadyInUse:
            self = .emailAlreadyInUse
        case .networkError, .webContextAlreadyPresented:
            self = .networkError
        case .webSignInUserInteractionFailure:
            self = .signInFailure
        default:
            self = .other(message: error.localizedDescription)
        }
    }
    
}
