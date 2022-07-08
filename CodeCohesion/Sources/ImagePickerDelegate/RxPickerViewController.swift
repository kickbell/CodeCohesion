//
//  RxPickerViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class RxPickerViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func onLoadImage(_ sender: Any) {
        let picker = UIImagePickerController()
        present(picker, animated: true, completion: nil)
        
        picker.rx.didFinishPickingMediaWithInfo
            .map { $0[UIImagePickerController.InfoKey.originalImage] as? UIImage }
            .bind(to: imageView.rx.image)
            .disposed(by: rx.disposeBag)
    }
    
}
