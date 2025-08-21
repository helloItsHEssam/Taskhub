//
//  NewTaskViewModel.swift
//  TasksHub
//
//  Created by HEssam on 8/7/25.
//

import Foundation
import SwiftUI

final class NewTaskViewModel {
    typealias Store = NewTaskModel.NewTaskStore
    typealias Intent = NewTaskModel.NewTaskIntent
    typealias State = NewTaskModel.NewTaskState
    
    var store: Store = Store()
    
    var state: State {
        store.state
    }
    
    func send(_ intent: Intent) {
        let action = intent.mapToAction()
        store.send(action)
    }
}
