//
//  TaskCell.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/14.
//

import UIKit

import ReactorKit
import RxSwift
import Then

class TaskCell: BaseTableViewCell, View {
    typealias Reactor = TaskCellReactor
    
    // MARK: Constants
    
    struct Constant {
        static let titleLabelNumberOfLines = 2
    }
    
    struct Metric {
        static let cellPadding: CGFloat = 15.0
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 14)
    }
    
    struct Color {
        static let titleLabelText = UIColor.black
    }
    
    /*
     currentState 는 TaskCellReactor 의 State 이므로 Task 타입이다.
     따라서 id, title, isDone, memo를 사용할 수가 있다.
     */
    func bind(reactor: Reactor) {
        self.titleLabel.text = reactor.currentState.title
        self.accessoryType = reactor.currentState.isDone ? .checkmark : .none
    }
    
    // MARK: - UI
    
    let titleLabel = UILabel().then {
        $0.font = Font.titleLabel
        $0.textColor = Color.titleLabelText
        $0.numberOfLines = Constant.titleLabelNumberOfLines
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(self.titleLabel)
      
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Metric.cellPadding),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Metric.cellPadding),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Metric.cellPadding),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Metric.cellPadding),
        ])
        
    }
}
