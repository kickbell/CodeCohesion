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
        case updateTaskTitle(String)
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
        case .cancel: //캔슬에서 또 2가지 액션을 나눠서 줄 수 있는 것이야.
            let alertActions: [TaskEditViewCancelAlertAction] = [.leave, .stay]
            return self.provider.alertService
                .show(
                    title: "Really?",
                    message: "All changes will be lost",
                    preferredStyle: .alert,
                    actions: alertActions)
                .flatMap { action -> Observable<Mutaion> in
                    switch action {
                    case .stay:
                        //이게 좀 의아한데,, UIAlertAction.Style에 cancel, destructive, default 가 있잖아.
                        //근데 여기서 default, cancel 만 해도 알아서 얼랏이 닫히는 것 같애. 그래서 empty() 라서
                        //뭐라까.. reduce에서 처리해주는 게 없더라도 닫히나봐 아마도..? [
                        return Observable.empty()
                    case .leave: return Observable.just(.dismiss)
                    }
                }
        case .sumbit:
            guard self.currentState.canSubmit else { return .empty() }
            return self.provider.taskService
                .create(title: self.currentState.taskTitle, memo: nil)
                .map { _ in .dismiss }
                .do(onNext: { ss in
                    self.provider.taskService
                })
            
        case let .updateTaskTitle(taskTitle):
            return Observable.just(.updateTaskTitle(taskTitle))
        }
    }
    
    func reduce(state: State, mutation: Mutaion) -> State {
        var state = state
        switch mutation {
        case .dismiss:
            state.isDismissed = true
            return state
        case let .updateTaskTitle(taskTitle):
            state.taskTitle = taskTitle
            state.canSubmit = !taskTitle.isEmpty
            return state
        }
    }
}
