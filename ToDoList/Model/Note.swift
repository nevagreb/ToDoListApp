//
//  Note.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import Foundation

// структура - модель данных для списка задач
struct NotesList {
    var notes: [Note] = []

    // инициализация тестовых данных
    init() {
        notes.append(Note(title: "Прочитать книгу1",
                          description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                          date: .now,
                          isDone: true))
        notes.append(Note(title: "Прочитать книгу2",
                          description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                          date: .now,
                          isDone: false))
        notes.append(Note(title: "Прочитать книгу3",
                          description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                          date: .now,
                          isDone: false))
    }
    
    // функция поиска индекса в массиве по id элемента
    func findIndex(of id: UUID) -> Int? {
        notes.firstIndex(where: {id == $0.id})
    }
    
    // функция выбора элемента массива по id
    mutating func markAsDone(with id: UUID) {
        if let index = findIndex(of: id) {
            notes[index].isDone.toggle()
        }
    }
    
    // функция сохраенения изменений, если задача нет - она добавлется,
    // если есть - обновляются свойства задачи
    mutating func save(at id: UUID?, with title: String, _ description: String) {
        if let id = id {
            update(at: id, with: title, description)
        } else {
            notes.append(Note(title: title, description: description))
        }
    }
    
    // функция обновления свойств задачи
    mutating func update(at id: UUID, with title: String, _ description: String) {
        if let index = findIndex(of: id) {
            notes[index].title = title
            notes[index].description = description
        }
    }
      
    // функция удаления задачи по ее id
    mutating func delete(with id: UUID) {
        if let index = findIndex(of: id) {
            notes.remove(at: index)
        }
    }
    
    // функция формирования задачи как текста
    func returnNoteAsText(with id: UUID) -> String {
        if let index = findIndex(of: id) {
            return notes[index].noteAsText
        }
        return ""
    }
    
    // структура - модель данных элемента списка задач
    struct Note: Identifiable, Hashable {
        var title: String
        var description: String
        var date: Date = .now
        var isDone: Bool = false
        var id: UUID = UUID()
        
        var noteAsText: String {
            self.title + "\n" + self.date.formattedAsShortDate() + "\n" + self.description
        }
    }
}
