//
//  GitHubSignUpViewModel.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/7/22.
//

import RxSwift
import RxCocoa
import NSObject_Rx

/*
 뷰모델 또는 프레젠터
 immutable VMs"를 사용한 예시를 살펴보고 싶다면 `TableViewWithEditingCommands` 예시를 살펴보세요.
 명시적인 상태는 없고, 출력은 입력과 디펜던시를 사용하여 정의됩니다.
 구독이 진행되고 있지 않기 때문에 disposeBag이 없다.
 */
class GitHubSignUpViewModel {
    
    // Output
    let validatedUserName: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let validatedPasswordRepeated: Driver<ValidationResult>
    
    // Is signup button enabled
    let signupEnabled: Driver<Bool>
    
    // Has user signed in
    let signedIn: Driver<Bool>
    
    // Is signing process in progress
    let signingIn: Driver<Bool>
    
    init(
        input: (
            username: Driver<String>,
            password: Driver<String>,
            repeatedPassword: Driver<String>,
            loginTaps: Signal<()>
        ),
        dependency: (
            API: GitHubAPI,
            validationService: GitHubValidationService,
            wireframe: Wireframe
        )
    ) {
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        
        /*
         '드라이버'를 사용할 때 기본 관찰 가능한 시퀀스 요소는 다음과 같은 이유로
         공유됩니다.
         드라이버는 후드 아래에 "shareReplay(1)"를 자동으로 추가합니다.
         (이건 무슨 뜻인지 잘 이해안감)
         
         .observe(on:MainScheduler.instance)
         .catchAndReturn(.Failed(message: "서버 연결 오류"))
         
         이 2가지를 이걸로 대체 가능
         `.asDriver(onErrorJustReturn: .Failed(message: "Error contacting server"))`
         */
        
        validatedUserName = input.username
            .flatMapLatest { username in
                return validationService.validateUsername(username) //Observable<ValidationResult>
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
            }
        
        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
            }
        
        validatedPasswordRepeated = Driver.combineLatest(input.password,
                                                         input.repeatedPassword,
                                                         resultSelector: validationService.validateRepeatedPassword)
        
        let signingIn = ActivityIndicator()
        self.signingIn = signingIn.asDriver()
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { (username: $0, password: $1) }
        
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest({ pair in
                return API.signup(pair.username, password: pair.password)
                    .trackActivity(signingIn)
                    .asDriver(onErrorJustReturn: false)
            })
            .flatMapLatest({ loggedIn -> Driver<Bool> in
                let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    .map { _ in return loggedIn }
                    .asDriver(onErrorJustReturn: false)
            })
        
        signupEnabled = Driver.combineLatest(
            validatedUserName,
            validatedPassword,
            validatedPasswordRepeated,
            signingIn
            , resultSelector: { username, password, repeatPassword, signingIn in
                username.isValid &&
                password.isValid &&
                repeatPassword.isValid &&
                !signingIn
            })
        .distinctUntilChanged()
        
    }
}
