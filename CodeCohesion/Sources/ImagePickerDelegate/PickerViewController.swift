//
//  DelegateViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit

class PickerViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePickerWrapper: ImagePickerWrapper!
    
    @IBAction func onLoadImage(_ sender: Any) {
        imagePickerWrapper = ImagePickerWrapper()
        imagePickerWrapper.showImagePicker(on: self)
        imagePickerWrapper.onImagePickedCallback = { [weak self] image in
            self?.imageView.image = image
        }
    }
    
}

