//
//  GitHubSignUpViewController.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/7/22.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class GitHubSignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidationOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidationOutlet: UILabel!
    
    @IBOutlet weak var repeatedPasswordOutlet: UITextField!
    @IBOutlet weak var repeatedPasswordValidationOutlet: UILabel!
    
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var signingUpOulet: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        
        //Input
        let viewModel = GitHubSignUpViewModel(
            input: (
                username: usernameOutlet.rx.text.orEmpty.asDriver(),
                password: passwordOutlet.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordOutlet.rx.text.orEmpty.asDriver(),
                loginTaps: signupOutlet.rx.tap.asSignal()
            ),
            dependency: (
                API: GitHubDefaultAPI.sharedAPI,
                validationService: GitHubDefaultValidationService.sharedValidationService,
                wireframe: DefaultWireframe.shared
            )
        )
        
        
        
        //Output
        viewModel.signupEnabled
            .drive(signupOutlet.rx.enabledResult)
//            .drive(onNext: { [weak self] valid in
//                self?.signupOutlet.isEnabled = valid
//                self?.signupOutlet.alpha = valid ? 1.0 : 0.5
//            })
            .disposed(by: rx.disposeBag)
                
        viewModel.validatedUserName
            .drive(usernameValidationOutlet.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.validatedPassword
            .drive(passwordValidationOutlet.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.validatedPasswordRepeated
            .drive(repeatedPasswordValidationOutlet.rx.validationResult)
            .disposed(by: rx.disposeBag)
        
        viewModel.signingIn
            .drive(signingUpOulet.rx.isAnimating)
            .disposed(by: rx.disposeBag)
        
        viewModel.signedIn
            .drive(onNext: { signedIn in
                print("User signed in \(signedIn)")
            })
            .disposed(by: rx.disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: rx.disposeBag)
        view.addGestureRecognizer(tapBackground)
        
    }
    
}
