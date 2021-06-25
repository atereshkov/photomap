//
//  ImagePickerProtocol.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6/25/21.
//

import UIKit
import Combine

protocol ImagePickerProtocol where Self: Coordinator {
    var imagePickerSourceSubject: PassthroughSubject<UIImagePickerController.SourceType, Never> { get }
    var showImagePickerSubject: PassthroughSubject<UIImagePickerController, Never> { get }
}
