//
//  AlertService.swift
//  RxTodo
//
//  Created by Suyeol Jeon on 29/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxSwift
import URLNavigator

/*
 TaskEditViewCancelAlertAction 에 적용하기 위해서.
 물론 여기말고도 다른데도 적용할 수 있을 것이다. 왜 만들었는지 알겠음.
 */
protocol AlertActionType {
    var title: String? { get }
    var style: UIAlertAction.Style { get }
}

extension AlertActionType {
    var style: UIAlertAction.Style {
        return .default
    }
}

protocol AlertServiceType: AnyObject {
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action>
}

final class AlertService: BaseService, AlertServiceType {
    
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action> {
        return Observable.create { observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alert.addAction(alertAction)
            }
            Navigator().present(alert)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
