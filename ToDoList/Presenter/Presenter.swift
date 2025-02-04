//
//  Presenter.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 03.02.2025.
//

import Combine
import SwiftUI

// класс - презентер
class Presenter: ObservableObject {
    @Published var notes: [ToDoNote] = []
    // состояние загрузки в Interactor
    @Published var isFetching: Bool = false
    // состояние навигации в Router
    @Published var currentScreen: Router.Screen = .toDoList
    
    private let interactor: Interactor
    private let router: Router
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: Interactor, router: Router) {
        self.interactor = interactor
        self.router = router
        setupBindings()
    }
    
    // настройка подписок
    func setupBindings() {
        // подписка на изменение данных массива задач в Interactor
        interactor.model.$notes
            .assign(to: \.notes, on: self)
            .store(in: &cancellables)
        
        // подписка на изменение состояния загрузки в Interactor
        interactor.$isFetching
            .assign(to: \.isFetching, on: self)
            .store(in: &cancellables)
        
        // подписка на изменение состояния навигации в Router
        router.$currentScreen
            .assign(to: \.currentScreen, on: self)
            .store(in: &cancellables)
    }
    
    // загрузка данных с сервера, если необходимо
    func loadNotesIfNeeded() async {
        await interactor.loadNotesIfNeeded()
    }
    
    // функция добавления новой задачи
    func addNewNote() -> ToDoNote {
      interactor.addNewNote()
    }
    
    // функция удаления задачи
    func delete(_ note: ToDoNote) {
      interactor.delete(note)
    }
    
    // функция отметки задачи как выполненной
    func markAsDone(_ note: ToDoNote) {
        interactor.markAsDone(note)
    }
    
    // функция редактирования задачи
    func edit(_ note: ToDoNote, title: String, description: String) {
        interactor.edit(note, title: title, description: description)
    }
    
    // функция фильтрации задач
    func updateQuery(_ query: String) {
        interactor.updateQuery(query)
    }
    
    // метод для перехода на экран детального вида
    func navigate(to note: ToDoNote) {
        router.navigate(to: note)
    }
    
    // метод для возврата на список задач
    func goBack() {
        router.goBack()
    }
}
