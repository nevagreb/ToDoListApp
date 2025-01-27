//
//  Note.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import Foundation

// структура - модель данных для списка задач
struct NotesList {
    private(set) var notes: [Note] = []
    
    // инициализация тестовых данных
    init() {
        notes.append(Note(title: "Прочитать книгу",
                          description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                          date: .now,
                          isSelected: true))
        notes.append(Note(title: "Прочитать книгу",
                          description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                          date: .now,
                          isSelected: false))
        notes.append(Note(title: "Прочитать книгу",
                          description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
                          date: .now,
                          isSelected: false))
    }
    
    // функция поиска индекса в массиве по id элемента
    func findIndex(of id: UUID) -> Int? {
        notes.firstIndex(where: {id == $0.id})
    }
    
    // функция выбора элемента массива по id
    mutating func selectNote(with id: UUID) {
        if let index = findIndex(of: id) {
            notes[index].isSelected.toggle()
        }
    }
    
    // структура - модель данных элемента списка задач
    struct Note: Identifiable {
        var title: String
        var description: String
        var date: Date
        var isSelected: Bool
        var id: UUID = UUID()
    }
}
