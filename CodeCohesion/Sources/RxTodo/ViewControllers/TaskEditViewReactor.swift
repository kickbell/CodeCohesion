//
//  TaskEditViewReactor.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/19/22.
//

import RxSwift
import ReactorKit

//같은 화면이지만 다르게 대응해야 하니까
enum TaskEditViewMode {
    case new
    case edit(Task)
}

//입력 후 취소하면 실행할 액션
//여기때문에 AlertActionType 프로토콜을 만들었구나.. 좋다. 굳굳.
enum TaskEditViewCancelAlertAction: AlertActionType {
    case leave
    case stay
    
    var title: String? {
        switch self {
        case .leave:
            return "Leave"
        case .stay:
            return "Stay"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .leave:
            return .destructive
        case .stay:
            return .default
        }
    }
}

final class TaskEditViewReactor: Reactor {
    
    enum Action {
        case cancel
        case sumbit
        case updateTaskTitle(String)
    }
    
    enum Mutaion {
        case dismiss
    }
    
    struct State {
        var title: String
        var taskTitle: String
        var canSubmit: Bool
        var shouldConfirmCancel: Bool
        var isDismissed: Bool
        
        init(title: String, taskTitle: String, canSubmit: Bool) {
            self.title = title
            self.taskTitle = taskTitle
            self.canSubmit = canSubmit
            self.shouldConfirmCancel = false
            self.isDismissed = false
        }
    }
    
    let provider: ServiceProviderType
    let mode: TaskEditViewMode
    let initialState: State
    
    init(provider: ServiceProviderType, mode: TaskEditViewMode) {
        self.provider = provider
        self.mode = mode
        
        switch mode {
        case .new:
            self.initialState = State(title: "New", taskTitle: "", canSubmit: false)
        case .edit(let task):
            self.initialState = State(title: "Edit", taskTitle: task.title, canSubmit: true)
        }
    }
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .cancel:
            return Observable.just(.dismiss)
        case .sumbit:
            return Observable.just(.dismiss)
        case .updateTaskTitle(_):
            return Observable.empty()
        }
    }
    
    func reduce(state: State, mutation: Mutaion) -> State {
        var state = state
        switch mutation {
        case .dismiss:
            state.isDismissed = true
            return state
        }
    }
}
