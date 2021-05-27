//
//  ImagePickerCoordinator.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 5/27/21.
//

import UIKit
import Combine

class ImagePickerCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController = UINavigationController()

    private(set) var selectedPhotoSubject = PassthroughSubject<Photo, Never>()

    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self

        return picker
    }()

    func start(from source: UIImagePickerController.SourceType) -> UIImagePickerController {
        picker.sourceType = source

        return picker
    }

}

extension ImagePickerCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        selectedPhotoSubject.send(Photo(image: image))
    }
}
