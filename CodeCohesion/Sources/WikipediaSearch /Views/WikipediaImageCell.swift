//
//  WikipediaImageCell.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class WikipediaImageCell: UICollectionViewCell {
    
    @IBOutlet var imageOutlet: UIImageView!
    
    var downloadableImage: Observable<DownloadableImage>? {
        didSet {
            self.downloadableImage?
                .asDriver(onErrorJustReturn: DownloadableImage.offlinePlaceholder)
                .drive(imageOutlet.rx.downloadableImageAnimated(CATransitionType.fade.rawValue))
                .disposed(by: rx.disposeBag)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadableImage = nil
    }

}

enum DownloadableImage{
    case content(image: UIImage)
    case offlinePlaceholder
}


extension Reactive where Base: UIImageView {

    var downloadableImage: Binder<DownloadableImage>{
        downloadableImageAnimated(nil)
    }

    func downloadableImageAnimated(_ transitionType: String?) -> Binder<DownloadableImage> {
        return Binder(base) { imageView, image in
            for subview in imageView.subviews {
                subview.removeFromSuperview()
            }
            switch image {
            case .content(let image):
                (imageView as UIImageView).rx.image.on(.next(image))
            case .offlinePlaceholder:
                let label = UILabel(frame: imageView.bounds)
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 35)
                label.text = "⚠️"
                imageView.addSubview(label)
            }
        }
    }
}
