//
//  ServiceProvider.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/18.
//

protocol ServiceProviderType: AnyObject {
    var taskService: TaskServiceType { get }
}


final class ServiceProvider: ServiceProviderType {
    lazy var taskService: TaskServiceType = TaskService(provider: self)
}
