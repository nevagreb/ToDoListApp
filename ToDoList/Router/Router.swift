//
//  Router.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 28.01.2025.
//

import SwiftUI

// класс - роутер для навигации
final class Router: ObservableObject {
    @Published var currentScreen: Screen = .toDoList
    
    enum Screen {
        case toDoList
        case toDo(note: NotesList.Note?)
    }
    
    // метод для перехода на экран детального вида
    func navigate(to note: NotesList.Note) {
        currentScreen = .toDo(note: note)
    }
    
    // метод для перехода на экран новой задачи
    func navigateToNew() {
        currentScreen = .toDo(note: nil)
    }
    
    // метод для возврата на список задач
    func goBack() {
        currentScreen = .toDoList
    }
}
