//
//  GeolocationService.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/07.
//

import CoreLocation
import RxSwift
import RxCocoa


class GeolocationService {
    
    static let share = GeolocationService()
    
    //    외부에서 읽기만 가능하고, 내부에서는 쓰기가 가능하도록
    private(set) var authorized: Driver<Bool>
    private(set) var location: Driver<CLLocationCoordinate2D>
    private let locationManager = CLLocationManager()
    
    
    //authorized, location를 configure와 같은 메소드로 빼면 다음 에러가 발생.
    //'self' used in method call 'configure' before all stored properties are initialized
    //모든 저장된 속성이 초기화되기 전에 'configure' 메서드 호출에 'self'가 사용되었습니다.
    //Return from initializer without initializing all stored properties
    //저장된 모든 속성을 초기화하지 않고 초기화에서 반환
    private init() {
        
        locationManager.distanceFilter = kCLHeadingFilterNone //??
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation //정확도 설정
        
        //구독이 일어나는 시점이 되서야 옵저버블을 생성한다.
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            
            return locationManager.rx
                .didChangeAuthorizationStatus
                .startWith(status)
        }
        .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
        .map { status -> Bool in
            switch status {
            case .authorizedAlways: return true //항상 허용
            case .authorizedWhenInUse: return true //앱 사용 중에만 허용
            default: return false
            }
        }
        
        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap({
                $0.last.map(Driver.just) ?? Driver.empty()
            })
            .map { $0.coordinate }
        
        locationManager.requestAlwaysAuthorization() //권한 요청
        locationManager.startUpdatingLocation() //지속적인 위치 업데이트
        
    }
}








