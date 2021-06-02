//
//  AlertError.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation

enum AlertError: GeneralErrorType {

    case networkConnection
    case other(message: String)

    var title: String {
        L10n.error
    }

    var message: String {
        switch self {
        case .networkConnection:
            return L10n.InternetError.ErrorAlert.Title.noNetworkConnection
        case .other(let message):
            return message
        }
    }
    
}
