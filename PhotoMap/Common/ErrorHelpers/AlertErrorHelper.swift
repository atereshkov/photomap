//
//  AlertErrorHelper.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation

enum AlertErrorHelper: ErrorHelper {
    case incorrectCredentials
    case networtConnection
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
        case .other(let message):
            return message.localized
        }
    }
}
