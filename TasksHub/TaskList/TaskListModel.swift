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
    }

    enum TaskListIntent: MVIIntent {
        typealias Action = TaskListAction
        
        case fetchTasks
        case completeTask(taskID: String)
        
        func mapToAction() -> TaskListAction {
            switch self {
            case .fetchTasks: TaskListAction.fetchTasks
            case let .completeTask(taskID): TaskListAction.completeTask(taskID: taskID)
            }
        }
    }
    
    enum TaskListResult: MVIResult {
        case taskList([MyTask])
    }
    
    struct TaskListProcessor: MVIProcessor {
        typealias Action = TaskListAction
        typealias Result = TaskListResult
        
        private var repository = MockRepository()
        
        func process(_ action: TaskListAction) -> TaskListResult {
            switch action {
            case .fetchTasks:
                return TaskListResult.taskList(repository.tasks)
                
            case let .completeTask(taskID):
                repository.completeTask(taskID: taskID)
                return .taskList(repository.tasks)
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
            case .taskList(let tasks): newState.tasks = tasks
            }
            
            return newState
        }
    }
    
    enum TaskListNavigator: MVINavigator { }
    
    @Observable
    final class TaskListStore: MVIStore {
        typealias Reducer = TaskListReducer
        typealias Processor = TaskListProcessor
        typealias Action = TaskListAction
        typealias State = TaskListState
        typealias Navigator = NavigationPath
        
        var processor: TaskListProcessor = TaskListProcessor()
        var state: TaskListState = TaskListState()
        var navigator: NavigationPath = NavigationPath()
        var reducer: TaskListReducer = TaskListReducer()
        
        func send(_ action: TaskListAction) {
            let result = processor.process(action)
            
            switch result {
            case .taskList:
                state = reducer.reduce(result, currentState: state)
            }
        }
    }
}
