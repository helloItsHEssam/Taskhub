//
//  MockRepository.swift
//  TasksHub
//
//  Created by HEssam on 8/7/25.
//

import Foundation

final class MockRepository {
    
    private(set) var tasks: [MyTask] = [
        .init(
            title: "hessam",
            date: .now,
            isCompleted: false
        ),
        .init(
            title: "hessam 2",
            date: Date(timeIntervalSince1970: 12321312),
            isCompleted: true
        )
    ]
    
    func completeTask(taskID: String) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[taskIndex].isCompleted = true
    }
    
    func insertTask(task: MyTask) {
        tasks.insert(task, at: 0)
    }
}
