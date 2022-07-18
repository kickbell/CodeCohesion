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
        case refresh
        case deleteTask(IndexPath)
    }
    
    enum Mutation {
        case setSections([TaskListSection])
        case deleteSectionItem(IndexPath)
    }
    
    struct State {
        var sections: [TaskListSection]
    }
    
    let provider: ServiceProviderType
    let initialState: State
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(
            sections: [TaskListSection(model: Void(), items: [])]
        )
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .deleteTask(indexPath):
            //원래는 이건데 Array+SectionModel에 subscript가 추가되어 있다. 공부할 것.
            //let task = self.currentState.sections[indexPath.section].items[indexPath.item].currentState
            //TaskListViewReactor에서 셀인 TaskCellReactor의 currentState을 가져오고 있음.
            //해당 currentState은 특정 값이 아니라 Task 타입이다.
            let task = self.currentState.sections[indexPath].currentState
            return self.provider.taskService
                .delete(taskID: task.id)
                .map { task in
                    //여기서 쓸거면 의미가 있어.
                    //일단 이렇게 바꿔보자. 리턴값을 이렇게 받아다가 쓴다고 치자고.
                    //그러면 의미가있다. 
                    return .deleteSectionItem(indexPath)
                }
//                .flatMap { _ in Observable.empty() }
        case .refresh:
            return self.provider.taskService
                .fetchTasks()
                .map { tasks in
                    let sectionItmes = tasks.map(TaskCellReactor.init)
                    let section = TaskListSection(model: Void(), items: sectionItmes)
                    return .setSections([section])
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .deleteSectionItem(indexPath):
            state.sections.remove(at: indexPath)
            return state
        case let .setSections(sections):
            state.sections = sections
            return state
        }
    }
    
    private func indexPath(forTaskID taskID: String, from state: State) -> IndexPath? {
        let section = 0
        let item = state.sections[section].items.firstIndex { reactor in reactor.currentState.id == taskID }
        if let item = item {
            return IndexPath(item: item, section: section)
        } else {
            return nil
        }
    }
}


