//
//  MockRepository.swift
//  TasksHub
//
//  Created by HEssam on 8/7/25.
//

import Foundation

final class MockRepository {
    static let shared = MockRepository()
    
    enum TaskError: Error, Equatable, LocalizedError {
        case duplicated
        case emptyTitle
        
        var errorDescription: String? {
            switch self {
            case .duplicated:
                return "Task already exist"
                
            case .emptyTitle:
                return "Task title can not be empty"
            }
        }
    }
    
    private(set) var tasks: [MyTask] = []
    
    func completeTask(taskID: String) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[taskIndex].isCompleted = true
    }
    
    func uncompleteTask(taskID: String) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[taskIndex].isCompleted = false
    }
    
    func removeTask(taskID: String) {
        tasks.removeAll(where: { $0.id == taskID })
    }
    
    func insertTask(task: MyTask) throws(TaskError) {
        guard !tasks.contains(where: { $0.title == task.title }) else {
            throw .duplicated
        }
        
        guard !task.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw .emptyTitle
        }
        
        tasks.insert(task, at: 0)
    }
}
