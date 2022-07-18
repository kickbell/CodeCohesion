//
//  TaskEditViewReactor.swift
//  CodeCohesion
//
//  Created by jc.kim on 7/19/22.
//

import RxSwift
import ReactorKit

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
        
    }
    
    let initialState: State = State()
}
