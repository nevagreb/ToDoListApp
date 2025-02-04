//
//  Interactor.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 03.02.2025.
//

import Foundation

// класс - интерактор, обеспечивает
// взаимодействие с сетью и CoreData
class Interactor: ObservableObject {
    let model: CoreDataStack
    @Published var isFetching: Bool = false
    private var networkService: NetworkServiceProtocol = NetworkService()

    init (model: CoreDataStack) {
        self.model = model
    }
    
    // функция, вызывающая загрузку задач с сервера,
    // если это первая загрузка в приложении
    func loadNotesIfNeeded() async {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLoadedData")

        guard model.notes.isEmpty, isFirstLaunch else { return }
        
        await fetchData()
        
        UserDefaults.standard.set(true, forKey: "hasLoadedData")
    }
    
    // функции загрузки задач с сервера
    @MainActor
    func fetchData() async {
        isFetching = true
        
        do {
            let url = URL(string: "https://dummyjson.com/todos")!
            let data = try await networkService.fetchData(from: url)
            if let decodedResponse = try? JSONDecoder().decode(NotesList.self, from: data) {
                model.addNotesFromServer(decodedResponse)
            } else {
                print("Error decoding data")
            }
        } catch {
            print("Ошибка загрузки данных: \(error)")
        }
        
        isFetching = false
    }
    
    // функция добавления новой задачи
    func addNewNote() -> ToDoNote {
        model.addNewNote()
    }
    
    // функция удаления задачи
    func delete(_ note: ToDoNote) {
        model.delete(note)
    }
    
    // функция отмечает задачу как выполненную
    func markAsDone(_ note: ToDoNote) {
        model.markAsDone(note)
    }
    
    // функция редактирования заметки
    func edit(_ note: ToDoNote, title: String, description: String) {
        model.edit(note, title: title, description: description)
    }
    
    // функция фильтрации по ключевому слову
    func updateQuery(_ query: String) {
        model.fetchNotes(query: query)
    }
}
