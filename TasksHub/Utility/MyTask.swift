//
//  MyTask.swift
//  TasksHub
//
//  Created by HEssam on 8/7/25.
//


import SwiftUI

struct MyTask: Identifiable, Hashable {
    var id: String { title + date.description }
    let title: String
    let date: Date
    var isCompleted: Bool
}
