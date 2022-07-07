//
//  Reactive+UIImagePickerController.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/06.
//

import Foundation
import RxSwift

extension Reactive where Base: UIImagePickerController {
    
    /*
     이렇게 직접 델리게이트 메소드에 접근해서 가져오는 방법도 있지만, 곰튀김님 방법이 더 나은 것 같다.
     그리고 이렇게하면 종료시점? 을 맞추기가 애매해서.. onnext에다가 base.dismiss를 넣어주었다.
     collectionView.rx.itemSelected라던지 그런것들도 다 아래처럼 구현되어 있다.
     
     public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : Any]> {
         return RxImagePickerProxy.proxy(for: base)
             .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
             .map { $0.last as? [UIImagePickerController.InfoKey : Any] ?? [:] }
             .asObservable()
             .debug()
             .do(onNext: { _ in
                 self.base.dismiss(animated: true, completion:  nil)
             })
     }
     */
        
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : Any]> {
        return RxImagePickerProxy.proxy(for: base)
            .didFinishPickingMediaWithInfoSubject
            .asObservable()
            .do(onCompleted: {
                self.base.dismiss(animated: true, completion: nil)
            })
    }
    
    public var didCancel: Observable<Void> {
        return RxImagePickerProxy.proxy(for: base)
            .didCancelSubject
            .asObservable()
            .do(onCompleted: {
                self.base.dismiss(animated: true, completion: nil)
            })
    }
    
}
