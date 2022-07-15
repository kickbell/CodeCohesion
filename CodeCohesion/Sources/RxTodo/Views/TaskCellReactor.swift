//
//  TaskCellReactor.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/14.
//

import RxSwift
import ReactorKit


final class TaskCellReactor: Reactor {
    /*
     Action, Mutation, State 모두 associatedtype 이기 때문에 타입이 꼭 State
     일 필요는 없음. NoAction/NoMutaion이 Never 타입으로 구현되어 있음
     
     또, ReactorKit의 flow 상 Action, State는 필수이지만 Mutation은 필수는 아님
     실제 아래 코드를 보면 Mutaion = Action 인 것을 볼 수 있음. 그래서 Action,
     State는 구현해주고 Mutation은 구현하지 않아도 컴파일에러가 발생하지 않음.
     
     ┌──── Action ────┐
     │                │
     │                │
    View           Reactor
     │            (mutate(),
     │             reduce())
     │                │
     └──── State ─────┘
     
     associatedtype Action
     sociatedtype Mutation = Action
     associatedtype State
     */
    typealias Action = NoAction
    
    let initialState: Task
    
    init(_ task: Task) {
        self.initialState = task
    }
}


