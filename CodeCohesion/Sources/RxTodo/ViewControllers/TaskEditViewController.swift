//
//  TaskEditViewController.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/19/22.
//

import UIKit
import ReactorKit
import Then
import RxDataSources

class TaskEditViewController: BaseViewController, View {
    
    // MARK: Constants
    
    struct Metric {
        static let padding: CGFloat = 15.0
        static let titleInputCornerRadius: CGFloat = 5.0
        static let titleInputBorderWidth: CGFloat = 1 / UIScreen.main.scale
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 14)
    }
    
    struct Color {
        static let titleInputBorder = UIColor.lightGray
    }
    
    // MARK: - Properties
    
    typealias Reactor = TaskEditViewReactor
    
    // MARK: - UI
    
    let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    let titleInput = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.font = Font.titleLabel
        $0.placeholder = "Do something..."
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setup() {
        self.reactor = TaskEditViewReactor()
        self.navigationItem.leftBarButtonItem = cancelButtonItem
        self.navigationItem.rightBarButtonItem = doneButtonItem
        self.view.backgroundColor = .white
        self.view.addSubview(titleInput)
        self.title = "New"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleInput.becomeFirstResponder()
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            titleInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.padding),
            titleInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.padding),
            titleInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.padding)
        ])
    }
    
    func bind(reactor: Reactor) {
        cancelButtonItem.rx.tap
            .map { Reactor.Action.cancel }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        doneButtonItem.rx.tap
            .map { Reactor.Action.sumbit }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        titleInput.rx.text.orEmpty
            .map(Reactor.Action.updateTaskTitle)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //event가 2번 오는데 왜지 ?
        reactor.state.map(\.isDismissed)
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
              self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
