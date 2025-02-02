//
//  ContentView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 28.01.2025.
//

import SwiftUI

// структура - домашний экран со списком задач и навигацией
struct HomeScreen: View {
    @StateObject private var router: Router
    @StateObject private var toDoList: ToDoList

    init(router: Router) {
        _router = StateObject(wrappedValue: router)
        _toDoList = StateObject(wrappedValue: ToDoList(router: router))
    }
    
    var body: some View {
        NavigationView {
            switch toDoList.router.currentScreen {
            case .toDoList:
                ToDoListView()
            case .toDo(let note):
                ToDoView(note: note)
            }
        }
        .environmentObject(toDoList)
        .task {
            await toDoList.featchData()
        }
    }
}

