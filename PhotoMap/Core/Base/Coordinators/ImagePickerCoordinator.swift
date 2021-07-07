//
//  ImagePickerCoordinator.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 5/27/21.
//

import UIKit
import Combine
import CoreLocation

class ImagePickerCoordinator: NSObject, ChildCoordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    
    private var coordinate: CLLocationCoordinate2D
    private(set) var selectedPhotoSubject = PassthroughSubject<PhotoDVO, Never>()
    private(set) var dismissSubject = PassthroughSubject<Void, Never>()

    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self

        return picker
    }()

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

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
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }

        selectedPhotoSubject.send(PhotoDVO(image: image, coordinate: coordinate))
    }
}
