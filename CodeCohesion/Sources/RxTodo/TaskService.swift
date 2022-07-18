//
//  TaskService.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/18.
//

import RxSwift

enum TaskEvent {
    case delete(id: String)
    case move(id: String, to: Int)
}

protocol TaskServiceType {
    var event: PublishSubject<TaskEvent> { get }
    func fetchTasks() -> Observable<[Task]>
    
    // MARK: - 사실상 얘는 userdefault에 저장하는 것 빼고는 용도가 없어
    func saveTasks(_ tasks: [Task]) -> Observable<Void>
    
    func delete(taskID: String) -> Observable<Task>
    func move(taskId: String, to: Int) -> Observable<Task>
}

final class TaskService: BaseService, TaskServiceType {
    let event = PublishSubject<TaskEvent>.init()

    func fetchTasks() -> Observable<[Task]> {
        let defaultTasks: [Task] = [
          Task(title: "Go to https://github.com/devxoul"),
          Task(title: "Star repositories I am intersted in"),
          Task(title: "Make a pull request"),
        ]
//        let defaultTaskDictionaries = defaultTasks.map { $0.asDictionary() }
//        self.provider.userDefaultsService.set(value: defaultTaskDictionaries, forKey: .tasks)
        return .just(defaultTasks)
    }
    
    func saveTasks(_ tasks: [Task]) -> Observable<Void> {
//      let dicts = tasks.map { $0.asDictionary() }
//      self.provider.userDefaultsService.set(value: dicts, forKey: .tasks)
      return .just(Void())
    }
    
    func delete(taskID: String) -> Observable<Task> {
        return self.fetchTasks()
            .flatMap { [weak self] tasks -> Observable<Task> in
                
                
                guard let `self` = self else { return .empty() }
//                guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return .empty() }
                var tasks = tasks
                let deleteTask = tasks.removeLast()
                return self.saveTasks(tasks).map { deleteTask }
                
//                사실 여기 작업은 의미가 없어.
//                saveTasks(tasks) 이것만 의미가 있지. 유저디폴트에 새로 값을 세팅해주는 작업 말이야.
//                그 이후의 .map { deleteTask } 은 의미가 없어. 어차피 그거 갖다쓰는것도 아니고
//                밑에 event.onNext로 transfrom 으로 쓰니까.
                
//                return Observable.just(tasks.first!)
            }
            .do(onNext: { task in
                self.event.onNext(.delete(id: task.id))
            })
    }
    
    func move(taskId: String, to: Int) -> Observable<Task> {
        self.fetchTasks()
            .flatMap { tasks -> Observable<Task> in
                let task = tasks.first!
                return self.saveTasks([]).map { task }
            }
    }

}
