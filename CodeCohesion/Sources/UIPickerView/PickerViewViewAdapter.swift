//
//  PickerViewViewAdapter.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/08.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

/*
 Adapter - 다른 전기나 기계 장치를 서로 연결해서 작동할 수 있도록 만들어 주는 결합 도구
 DataAdapter - 데이터베이스에서 데이터를 채우거나 업데이트할 수 있는 도구 또는 클래스
 DataSource - DataSource는 DataSet, DataBase, XML 파일 등과 같이 데이터를 채우는 데이터 소스일 뿐입니다.
 Proxy - 서버와 클라이언트 사이에 중계기로서 대리로 통신을 수행하는 것을 가리킨다
 */

final class PickerViewViewAdapter: NSObject,
                                   UIPickerViewDelegate,
                                   UIPickerViewDataSource,
                                   RxPickerViewDataSourceType,
                                   SectionedViewDataSourceType {
    
    private var items: [[CustomStringConvertible]] = []
    
    // MARK: - RxPickerViewDataSourceType
    
    typealias Element = [[CustomStringConvertible]]
    
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        Binder(self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items[component].count
    }
    
    // MARK: - SectionedViewDataSourceType
    
    func model(at indexPath: IndexPath) throws -> Any {
        return items[indexPath.section][indexPath.row]
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = items[component][row].description
        label.textColor = UIColor.orange
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }
    
}
