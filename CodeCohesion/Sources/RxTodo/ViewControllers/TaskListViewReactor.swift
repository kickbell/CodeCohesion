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
        case moveTask(IndexPath, IndexPath)
    }
    
    enum Mutation {
        case setSections([TaskListSection])
        case deleteSectionItem(IndexPath)
        case moveSectionItem(IndexPath, IndexPath)
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
            return Observable.just(Void())
                .map { .deleteSectionItem(indexPath) }
        case .refresh:
            return self.provider.taskService
                .fetchTasks()
                .map { tasks in
                    let sectionItmes = tasks.map(TaskCellReactor.init)
                    let section = TaskListSection(model: Void(), items: sectionItmes)
                    return .setSections([section])
                }
        case let .moveTask(sourceIndexPath, destinationIndexPath):
            return Observable.just(Void())
                .map { .moveSectionItem(sourceIndexPath, destinationIndexPath)}
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
        case let .moveSectionItem(sourceIndexPath, destinationIndexPath):
            let sectionItem = state.sections.remove(at: sourceIndexPath)
            state.sections.insert(sectionItem, at: destinationIndexPath)
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


