//
//  APIWrappersViewController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/08.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class APIWrappersViewController: UIViewController {
    
    @IBOutlet weak var debugLabel: UILabel!

    @IBOutlet weak var openActionSheet: UIButton!

    @IBOutlet weak var openAlertView: UIButton!

    @IBOutlet weak var bbitem: UIBarButtonItem!

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var switcher: UISwitch!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var button: UIButton!

    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!

    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var mypan: UIPanGestureRecognizer!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: UITextView!

    let manager = CLLocationManager()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = Date(timeIntervalSince1970: 0)
        bind()
    }
    
    private func debug(_ string: String) {
        print(string)
        debugLabel.text = string
    }
    
    private func bind() {
        
        // MARK: UIBarButtonItem, UIBarButtonItem+Rx.swift

        bbitem.rx.tap
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIBarButtonItem Tapped")
            })
            .disposed(by: disposeBag)
        
        // MARK: UISegmentedControl

        // also test two way binding
        let segmentedValue = BehaviorRelay(value: 0)
        _ = segmentedControl.rx.value <-> segmentedValue

        segmentedValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISegmentedControl value \(x)")
            })
            .disposed(by: disposeBag)
    }
    

    

}
