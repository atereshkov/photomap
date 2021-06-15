//
//  FirestoreError.swift
//  PhotoMap
//
//  Created by yurykasper on 26.05.21.
//

import Foundation
import FirebaseStorage

enum FirestoreError: GeneralErrorType {
    case noCurrentUserId
    case unavailableLocalService
    case nonMatchingChecksum
    case noRules
    case imageDecoding
    case custom(String)
    
    var title: String {
        return L10n.error
    }
    
    var message: String {
        switch self {
        case .noCurrentUserId:
            return L10n.FirestoreError.NoCurrentId.message
        case .unavailableLocalService:
            return L10n.FirestoreError.UnavailableLocalService.message
        case .nonMatchingChecksum:
            return L10n.FirestoreError.NonMatchingChecksum.message
        case .noRules:
            return L10n.FirestoreError.NoRules.message
        case .imageDecoding:
            return L10n.FirestoreError.ImageDecoding.message
        case .custom(let message):
            switch message {
            case "can't get the url":
                return L10n.FirestoreError.WrongURL.message
            case "can't create path to file":
                return L10n.FirestoreError.WrongPath.message
            default:
                return self.localizedDescription
            }
        }
    }

    init(_ error: Error) {
        let nsError = error as NSError
        guard let errorCode = StorageErrorCode(rawValue: nsError.code) else {
            self = .custom(error.localizedDescription)
            return
        }
        
        switch errorCode {
        case .unknown:
            self = .custom(error.localizedDescription)
        case .nonMatchingChecksum:
            self = .nonMatchingChecksum
        case .unauthenticated:
            self = .noCurrentUserId
        case .unauthorized:
            self = .noRules
        default:
            self = .custom(error.localizedDescription)
        }
    }
}
