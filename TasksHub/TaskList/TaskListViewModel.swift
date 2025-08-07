//
//  TaskListViewModel.swift
//  TasksHub
//
//  Created by HEssam on 8/7/25.
//

import Foundation
import SwiftUI

@Observable
final class TaskListViewModel {
    typealias Store = TaskListModel.TaskListStore
    typealias Intent = TaskListModel.TaskListIntent
    typealias State = TaskListModel.TaskListState
    
    var store: Store = Store()
    
    var state: State {
        store.state
    }
    
    func send(_ intent: Intent) {
        let action = intent.mapToAction()
        store.send(action)
    }
}
