//
//  TaskListModel.swift
//  TasksHub
//
//  Created by HEssam on 6/27/25.
//

import Foundation
import SwiftUI

enum TaskListModel {

    enum TaskListAction: MVIAction {
        case fetchTasks
        case completeTask(taskID: String)
        case uncompleteTask(taskID: String)
        case removeTask(taskID: String)
        case navigateToCreateNewTask
    }

    enum TaskListIntent: MVIIntent {
        typealias Action = TaskListAction
        
        case fetchTasks
        case completeTask(taskID: String)
        case uncompleteTask(taskID: String)
        case removeTask(taskID: String)
        case navigateToCreateNewTask
        
        func mapToAction() -> TaskListAction {
            switch self {
            case .fetchTasks: .fetchTasks
            case let .completeTask(taskID): .completeTask(taskID: taskID)
            case let .uncompleteTask(taskID): .uncompleteTask(taskID: taskID)
            case let .removeTask(taskID): .removeTask(taskID: taskID)
            case .navigateToCreateNewTask: .navigateToCreateNewTask
            }
        }
    }
    
    enum TaskListResult: MVIResult {
        case taskList([MyTask])
        case navigateToCreateNewTask
    }
    
    struct TaskListProcessor: MVIProcessor {
        typealias Action = TaskListAction
        typealias Result = TaskListResult
        
        private var repository = MockRepository.shared
        
        func process(_ action: TaskListAction) -> TaskListResult {
            switch action {
            case .fetchTasks:
                return TaskListResult.taskList(repository.tasks)
                
            case let .completeTask(taskID):
                repository.completeTask(taskID: taskID)
                return .taskList(repository.tasks)
                
            case let .uncompleteTask(taskID):
                repository.uncompleteTask(taskID: taskID)
                return .taskList(repository.tasks)
                
            case let .removeTask(taskID):
                repository.removeTask(taskID: taskID)
                return .taskList(repository.tasks)
                
            case .navigateToCreateNewTask: return .navigateToCreateNewTask
            }
        }
    }
    
    struct TaskListState: MVIState {
        var tasks: [MyTask] = []
    }
    
    struct TaskListReducer: MVIReducer {
        typealias Result = TaskListResult
        typealias State = TaskListState
        
        func reduce(_ result: TaskListResult, currentState state: TaskListState) -> TaskListState {
            var newState = state
            
            switch result {
            case .taskList(let tasks):
                newState.tasks = tasks
                
            case .navigateToCreateNewTask: break
            }
            
            return newState
        }
    }
    
    enum TaskListNavigator: MVINavigator {
        case navigateToCreateNewTask
    }
    
    @Observable
    final class TaskListStore: MVIStore {
        typealias Reducer = TaskListReducer
        typealias Processor = TaskListProcessor
        typealias Action = TaskListAction
        typealias State = TaskListState
        typealias Navigator = NavigationPath
        
        var processor: TaskListProcessor = TaskListProcessor()
        var state: TaskListState = TaskListState()
        var navigator: NavigationPath = NavigatorRepository.shared.navigation
        var reducer: TaskListReducer = TaskListReducer()
        
        func send(_ action: TaskListAction) {
            let result = processor.process(action)
            
            switch result {
            case .navigateToCreateNewTask:
                navigator.append(TaskListNavigator.navigateToCreateNewTask)
                
            default: state = reducer.reduce(result, currentState: state)
            }
        }
    }
}
