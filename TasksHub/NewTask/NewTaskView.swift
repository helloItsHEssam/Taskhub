//
//  NewTaskView.swift
//  TasksHub
//
//  Created by HEssam on 8/7/25.
//

import SwiftUI

struct NewTaskView: View {
    
    typealias InsertedTask = (MyTask) -> Void
    
    @State private var viewModel: NewTaskViewModel = .init()
    @State private var title = ""
    @State private var dueDate = Date()
    @State private var error: MockRepository.TaskError?
    
    private var insertedTaskCompletion: InsertedTask?
    
    init(insertedTaskCompletion: InsertedTask?) {
        self.insertedTaskCompletion = insertedTaskCompletion
    }
    
    var body: some View {
        Form {
            Section(footer: sectionFooter()) {
                TextField("Task Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
        }
        .onChange(of: viewModel.state.error, { _, newValue in
            self.error = newValue
        })
        .onChange(of: viewModel.state.insertedTask, { _, newValue in
            guard let newValue else { return }
            resetView()
            insertedTaskCompletion?(newValue)
        })
        .navigationTitle("New Task")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let task = MyTask(
                        title: title,
                        date: dueDate,
                        isCompleted: false
                    )
                    viewModel.send(.insertNewTask(task: task))
                }
            }
        }
    }
    
    private func resetView() {
        title = ""
        dueDate = Date()
    }
    
    @ViewBuilder
    private func sectionFooter() -> some View {
        if let error {
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.red)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    NewTaskView(insertedTaskCompletion: nil)
}
