//
//  File.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation

protocol GeneralErrorType: Error {
    
    var title: String { get }
    var message: String { get }
    
}
