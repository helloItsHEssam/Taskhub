//
//  NewTaskModel.swift
//  TasksHub
//
//  Created by HEssam on 8/7/25.
//

import Foundation
import SwiftUI

enum NewTaskModel {

    enum NewTaskAction: MVIAction {
        case insertNewTask(task: MyTask)
    }

    enum NewTaskIntent: MVIIntent {
        typealias Action = NewTaskAction
        
        case insertNewTask(task: MyTask)
        
        func mapToAction() -> NewTaskAction {
            switch self {
            case let .insertNewTask(task): .insertNewTask(task: task)
            }
        }
    }
    
    enum NewTaskResult: MVIResult {
        case insertedTask(MyTask)
        case error(MockRepository.TaskError)
    }
    
    struct NewTaskProcessor: MVIProcessor {
        typealias Action = NewTaskAction
        typealias Result = NewTaskResult
        
        private var repository = MockRepository.shared
        
        func process(_ action: NewTaskAction) -> NewTaskResult {
            switch action {
            case let .insertNewTask(task):
                do {
                    try repository.insertTask(task: task)
                    return .insertedTask(task)
                } catch {
                    return .error(error)
                }
            }
        }
    }
    
    struct NewTaskState: MVIState {
        var error: MockRepository.TaskError?
        var insertedTask: MyTask?
    }
    
    struct NewTaskReducer: MVIReducer {
        typealias Result = NewTaskResult
        typealias State = NewTaskState
        
        func reduce(_ result: NewTaskResult, currentState state: NewTaskState) -> NewTaskState {
            var newState = state
            
            switch result {
            case let .error(error):
                newState.error = error
                newState.insertedTask = nil
            
            case let .insertedTask(task):
                newState.error = nil
                newState.insertedTask = task
            }
            
            return newState
        }
    }
    
    enum NewTaskNavigator: MVINavigator {}
    
    @Observable
    final class NewTaskStore: MVIStore {
        typealias Reducer = NewTaskReducer
        typealias Processor = NewTaskProcessor
        typealias Action = NewTaskAction
        typealias State = NewTaskState
        typealias Navigator = NavigationPath
        
        var processor: NewTaskProcessor = NewTaskProcessor()
        var state: NewTaskState = NewTaskState()
        var navigator: NavigationPath = NavigatorRepository.shared.navigation
        var reducer: NewTaskReducer = NewTaskReducer()
        
        func send(_ action: NewTaskAction) {
            let result = processor.process(action)
            state = reducer.reduce(result, currentState: state)
        }
    }
}
