//
//  GeolocationViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/07.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class GeolocationViewController: UIViewController {
    
    @IBOutlet weak var geoPermissionDeniedView: UIView!
    @IBOutlet weak var geoPermissionDeniedButton: UIButton!
    
    @IBOutlet weak var geoPermissionAuthorizedButton: UIButton!
    @IBOutlet weak var geoLocationlabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func bind() {
        let geolocationService = GeolocationService.share
        
        geolocationService.authorized
            .debug()
            .drive(geoPermissionDeniedView.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        geolocationService.location
            .drive(geoLocationlabel.rx.coordinates)
            .disposed(by: rx.disposeBag)
        
        geoPermissionDeniedButton.rx.tap
            .debug()
            .bind(onNext: { [weak self] _ in
                self?.openAppPreferences()
            })
            .disposed(by: rx.disposeBag)
        
        geoPermissionAuthorizedButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.openAppPreferences()
            })
            .disposed(by: rx.disposeBag)
            
    }
      
    private func setupUI() {
        //noGeolocationView가 뷰컨 밖으로 따로 나와있기 때문에 아무것도 안해주면 AutoresizingMask가 적용되서 지맘대로 자리잡는다?
        //근데 이렇게 아예 밖으로 빼내도 되네.. 덮어쓰기? 같이 작업해야 되는줄 알았는데.
        //그래서 translatesAutoresizingMaskIntoConstraints를 false는 필수이다.
        view.addSubview(geoPermissionDeniedView)
        geoPermissionDeniedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            geoPermissionDeniedView.topAnchor.constraint(equalTo: view.topAnchor),
            geoPermissionDeniedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            geoPermissionDeniedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            geoPermissionDeniedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func openAppPreferences() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }

}

private extension Reactive where Base: UILabel {
    var coordinates: Binder<CLLocationCoordinate2D> {
        return Binder(base) { label, location in
            label.text = "Lat: \(location.latitude)\nLon: \(location.longitude)"
        }
    }
}
