//
//  FirestoreError.swift
//  PhotoMap
//
//  Created by yurykasper on 26.05.21.
//

import Foundation

enum FirestoreError: GeneralErrorType {
    case noCurrentUserId
    case custom(String)
    
    var title: String {
        return L10n.error
    }
    
    var message: String {
        switch self {
        case .noCurrentUserId:
            return "User is not authorized"
        case .custom(let message):
            return message
        }
    }
}