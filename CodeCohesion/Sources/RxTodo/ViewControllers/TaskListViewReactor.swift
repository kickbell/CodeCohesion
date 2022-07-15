//
//  TaskListViewReactor.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/14.
//

import RxSwift
import ReactorKit
import RxDataSources

typealias TaskListSection = SectionModel<Void, TaskCellReactor>

final class TaskListViewReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var sections: [TaskListSection]
    }
    
    let initialState: State
    
    let emptyResult: [TaskListSection] = [
        TaskListSection(
            model: Void(),
            items: [
                TaskCellReactor(Task(title: "potato", memo: "memo11")),
                TaskCellReactor(Task(title: "melon", memo: "memo22")),
                TaskCellReactor(Task(title: "strawberry", memo: "memo33")),
                TaskCellReactor(Task(title: "banana", memo: "memo44")),
                TaskCellReactor(Task(title: "watermelon", memo: "memo55")),
            ]
        )
    ]
    
    init() {
        self.initialState = State(
//            sections: [TaskListSection(model: Void(), items: [])]
            sections: emptyResult
        )
    }
    
}
