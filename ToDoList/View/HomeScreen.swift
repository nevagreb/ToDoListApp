//
//  ContentView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 28.01.2025.
//

import SwiftUI

// структура - домашний экран со списком задач и навигацией
struct HomeScreen: View {
    @StateObject var dataModel: CoreDataStack
    @StateObject var presenter: Presenter
    @StateObject private var router: Router = Router()

    init(router: Router, dataModel: CoreDataStack) {
        _dataModel = StateObject(wrappedValue: dataModel)
        _presenter = StateObject(wrappedValue: Presenter(interactor: Interactor(model: dataModel), router: router))
    }
    
    var body: some View {
        NavigationView {
            switch presenter.currentScreen {
            case .toDoList:
                ToDoListView()
            case .toDo(let note):
                ToDoView(note: note)
            }
        }
        .environmentObject(presenter)
    }
}

