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
    
    let imageService = DefaultImageService.sharedImageService

    var disposeBag: DisposeBag?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imagesOutlet.register(UINib(nibName: "WikipediaImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    
    var viewModel: SearchResultViewModel? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else {
                return
            }

            viewModel.title
                .map(Optional.init)
                .drive(self.titleOutlet.rx.text)
                .disposed(by: disposeBag)
            
            self.URLOutlet.text = viewModel.searchResult.URL.absoluteString
            
            let reachabilityService = Dependencies.sharedDependencies.reachabilityService
            
            viewModel.imageURLs
                .drive(self.imagesOutlet.rx.items(cellIdentifier: "ImageCell", cellType: WikipediaImageCell.self)) { [weak self] _, url, cell in
                    cell.imageOutlet.image = UIImage(systemName: "trash")
//                    cell.downloadableImage = self?.imageService.imageFromURL(url, reachabilityService: reachabilityService) ?? Observable.empty()
                 }
                .disposed(by: disposeBag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.viewModel = nil
        self.disposeBag = nil
    }
    
}
