//
//  ImagePickerWrapper.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit

class ImagePickerWrapper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var onImagePickedCallback: (UIImage) -> () = { _ in }
    
    func showImagePicker(on vc: UIViewController) {
        let picker = UIImagePickerController()
        picker.delegate = self
        vc.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalInfo = info[UIImagePickerController.InfoKey.originalImage]
        guard let originImage = originalInfo as? UIImage else { return }
        picker.dismiss(animated: true, completion: { [weak self] in
            self?.onImagePickedCallback(originImage)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
