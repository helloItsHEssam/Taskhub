//
//  TaskListView.swift
//  TasksHub
//
//  Created by HEssam on 6/27/25.
//

import SwiftUI

struct TaskListView: View {
    
    @State private var viewModel: TaskListViewModel = .init()
    
    var body: some View {
        NavigationStack(path: $viewModel.store.navigator) {
            VStack {
                List {
                    ForEach(viewModel.state.tasks) { task in
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                                .foregroundStyle(task.isCompleted ? Color.gray : .primary)
                            
                            Text("Due: \(task.date.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                if task.isCompleted {
                                    viewModel.send(.uncompleteTask(taskID: task.id))
                                } else {
                                    viewModel.send(.completeTask(taskID: task.id))
                                }                                
                            } label: {
                                Label("Complete", systemImage: task.isCompleted ? "xmark.circle" : "checkmark.circle")
                            }.tint(task.isCompleted ? .orange : .green)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.send(.removeTask(taskID: task.id))
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }.tint(.red)
                        }
                    }
                }
            }
            .navigationTitle("TasksHub")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.send(.navigateToCreateNewTask)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: TaskListModel.TaskListNavigator.self) { navigator in
                switch navigator {
                case .navigateToCreateNewTask:
                    NewTaskView(insertedTaskCompletion: { _ in
                        viewModel.send(.fetchTasks)
                    })
                }
            }
        }
        .onAppear {
            viewModel.send(.fetchTasks)
        }
    }
}

#Preview {
    TaskListView()
}
