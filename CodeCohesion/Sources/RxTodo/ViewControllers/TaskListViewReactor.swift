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
        case deleteTask(IndexPath)
    }
    
    enum Mutation {
        case deleteSectionItem(IndexPath)
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
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .deleteTask(indexPath):
            //원래는 이건데 Array+SectionModel에 subscript가 추가되어 있다. 공부할 것.
            //let task = self.currentState.sections[indexPath.section].items[indexPath.item].currentState
            let task = self.currentState.sections[indexPath].currentState
            
            return Observable.empty()
        }
    }
    
    
}


