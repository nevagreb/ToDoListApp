//
//  ToDoList.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import Foundation

// класс - ViewModel для списка задач
final class ToDoList: ObservableObject {
    @Published var notesList: NotesList
    @Published var router: Router
    
    init(router: Router) {
        self.notesList = NotesList()
        self.router = router
    }
    
    // массив задач
    var notes: [NotesList.Note] {
        notesList.notes
    }
    
    // MARK: - Intent(s)
    // функция для отметки задачи как выполненной по id
    func markAsDone(with id: UUID) {
        notesList.markAsDone(with: id)
    }
    
    // функция поиска индекса элемента массива по его id
    func findIndex(of id: UUID) -> Int? {
        notesList.findIndex(of: id)
    }
    
    // функция сохранения изменений
    func save(at id: UUID?, with title: String, _ description: String) {
        notesList.save(at: id, with: title, description)
    }
    
    // функция удаления элемента массива по его id
    func delete(with id: UUID) {
        notesList.delete(with: id)
    }
    
    // функция формирования задачи как текста
    func returnNoteAsText(with id: UUID) -> String {
        notesList.returnNoteAsText(with: id)
    }
}

// функции навигации
extension ToDoList {
    // функция перехода к детальному виду
    func navigate(to note: NotesList.Note) {
        router.navigate(to: note)
    }
    
    // функция перехода к новой задаче
    func navigateToNew() {
        router.navigateToNew()
    }
    
    // функция возврата к списку задач
    func goBack() {
        router.goBack()
    }
}
