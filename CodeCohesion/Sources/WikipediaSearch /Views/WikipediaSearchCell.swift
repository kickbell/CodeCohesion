//
//  WikipediaSearchCell.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/11/22.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class WikipediaSearchCell: UITableViewCell {
    
    @IBOutlet var titleOutlet: UILabel!
    @IBOutlet var URLOutlet: UILabel!
    @IBOutlet var imagesOutlet: UICollectionView!
    
    let imageURLs = BehaviorRelay<[UIImage?]>.init(value: [
        UIImage(systemName: "person.fill"),
        UIImage(systemName: "house"),
        UIImage(systemName: "photo.fill"),
        UIImage(systemName: "trash"),
        UIImage(systemName: "person"),
    ])

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imagesOutlet.register(UINib(nibName: String(describing: WikipediaImageCell.self), bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        
        imageURLs
            .asDriver(onErrorJustReturn: [])
            .drive(imagesOutlet.rx.items(cellIdentifier: "ImageCell", cellType: WikipediaImageCell.self)) { [weak self] _, image, cell in
                cell.imageOutlet.image = image
            }
            .disposed(by: rx.disposeBag)
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
