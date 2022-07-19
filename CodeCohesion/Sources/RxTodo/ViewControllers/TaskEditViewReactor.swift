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
enum TaskEditViewCancelAlertAction {
    case leave
    case stay
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
        var isDismissed: Bool
        
        init() {
            self.isDismissed = false
        }
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutaion> {
        switch action {
        case .cancel:
            return Observable.just(.dismiss)
        case .sumbit:
            return Observable.just(.dismiss)
        case let .updateTaskTitle(title):
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
