//
//  ImagePickerCoordinator.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 5/27/21.
//

import UIKit
import Combine
import CoreLocation

class ImagePickerCoordinator: NSObject, Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    
    weak var parentCoordinator: Coordinator?
    
    private var coordinate: CLLocationCoordinate2D
    private(set) var selectedPhotoSubject = PassthroughSubject<Photo, Never>()

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
        parentCoordinator?.childDidFinish(self)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        parentCoordinator?.childDidFinish(self)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }

        selectedPhotoSubject.send(Photo(image: image, coordinate: coordinate))
    }
}
