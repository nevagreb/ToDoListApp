//
//  Router.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 04.02.2025.
//

import SwiftUI

// класс - роутер, обеспечивает навигацию
class Router: ObservableObject {
    @Published var currentScreen: Screen = .toDoList
    
    enum Screen {
        case toDoList
        case toDo(note: ToDoNote)
    }
    
    // метод для перехода на экран детального вида
    func navigate(to note: ToDoNote) {
        self.currentScreen = .toDo(note: note)
    }
    
    // метод для возврата на список задач
    func goBack() {
        currentScreen = .toDoList
    }
}
