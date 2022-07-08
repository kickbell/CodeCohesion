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
        _ = segmentedControl.rx.value <-> segmentedValue // 컨트롤 속성과 릴레이 간의 양방향 바인딩 연산자란다. 그래서 이거 안해주면 밑에
        
        segmentedValue.asObservable() // 이 코드 동작 안해.
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISegmentedControl value \(x)")
            })
            .disposed(by: disposeBag)
        
//        근데 이렇게도 되니까 그냥 이거 쓰면 되지 않으까..? 차이가 뭐지.
//        segmentedControl.rx.value
//            .subscribe(onNext: { [weak self] x in
//                self?.debug("UISegmentedControl value \(x)")
//            })
//            .disposed(by: disposeBag)
        
        // MARK: UIActivityIndicatorView

        switcher.rx.value
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        // MARK: UIButton

        button.rx.tap
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIButton Tapped")
            })
            .disposed(by: disposeBag)
        
        // MARK: UISlider

        // also test two way binding
//        let sliderValue = BehaviorRelay<Float>(value: 1.0)
//        _ = slider.rx.value <-> sliderValue
//
//        sliderValue.asObservable()
//            .subscribe(onNext: { [weak self] x in
//                self?.debug("UISlider value \(x)")
//            })
//            .disposed(by: disposeBag)
        
        slider.rx.value
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISlider value \(x)")
            })
            .disposed(by: disposeBag)
        
        // MARK: UIDatePicker

//        // also test two way binding
//        let dateValue = BehaviorRelay(value: Date(timeIntervalSince1970: 0))
//        _ = datePicker.rx.date <-> dateValue
//
//        dateValue.asObservable()
//            .subscribe(onNext: { [weak self] x in
//                self?.debug("UIDatePicker date \(x)")
//            })
//            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIDatePicker date \(x)")
            })
            .disposed(by: disposeBag)
        
        
        // MARK: UITextField

        textField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextField text \(x)")
            })
            .disposed(by: disposeBag)
        
        textField.rx.attributedText
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextField attributedText \(x?.description ?? "")")
            })
            .disposed(by: disposeBag)
        
        
        // MARK: UIGestureRecognizer
        
        mypan.rx.event
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIGestureRecognizer event \(x.state.rawValue)")
            })
            .disposed(by: disposeBag)
        
        
        // MARK: UITextView

        // also test two way binding
        let textViewValue = BehaviorRelay(value: "")
        _ = textView.rx.textInput <-> textViewValue

        textViewValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextView text \(x)")
            })
            .disposed(by: disposeBag)

        let attributedTextViewValue = BehaviorRelay<NSAttributedString?>(value: NSAttributedString(string: ""))
        _ = textView2.rx.attributedText <-> attributedTextViewValue

        attributedTextViewValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextView attributedText \(x?.description ?? "")")
            })
            .disposed(by: disposeBag)
        
//        가능
//        textView.rx.text
//        textView.rx.attributedText
        
        
        // MARK: CLLocationManager
        // requestWhenInUseAuthorization 권한요청부터 꼭 하고 구독하고 그 이후에 startUpdatingLocation 해야되나봐. 중요체크.
        // 아래 이녀석들이 어떻게보면 진정한 래퍼임. 잘봐두셍. 공식예제엔 더 많이 있음.
        manager.requestWhenInUseAuthorization()

        manager.rx.didUpdateLocations
            .subscribe(onNext: { x in
                print("rx.didUpdateLocations \(x)")
            })
            .disposed(by: disposeBag)

        _ = manager.rx.didFailWithError
            .subscribe(onNext: { x in
                print("rx.didFailWithError \(x)")
            })
        
        manager.rx.didChangeAuthorizationStatus
            .subscribe(onNext: { status in
                print("Authorization status \(status)")
            })
            .disposed(by: disposeBag)
        
        manager.startUpdatingLocation()
    }

}
