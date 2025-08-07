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
                                viewModel.send(.completeTask(taskID: task.id))
                            } label: {
                                Label("Complete", systemImage: task.isCompleted ? "xmark.circle" : "checkmark.circle")
                            }.tint(task.isCompleted ? .orange : .green)
                        }
                    }
                }
            }
            .navigationTitle("TasksHub")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { /*showingAddTask = true*/ }) {
                        Image(systemName: "plus")
                    }
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
