//
//  Note.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import Foundation

// структура - модель данных для списка задач
struct NotesList: Decodable {
    var notes: [Note] = []
    
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
            let newNote = NotesList.Note(title: title,
                                         _description: description,
                                         _date: .now,
                                         isDone: false,
                                         userId: 0)
            notes.append(newNote)
        }
    }
    
    // функция обновления свойств задачи
    mutating func update(at id: UUID, with title: String, _ description: String) {
        if let index = findIndex(of: id) {
            notes[index].title = title
            notes[index]._description = description
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
    struct Note: Identifiable, Hashable, Decodable {
        var id: UUID = UUID()
        var _id: Int?
        var title: String
        var _description: String?
        var _date: Date?
        var isDone: Bool
        var userId: Int
        
        var description: String {
            if let _description = _description {
                return _description
            } else {
                return ""
            }
        }
        
        var date: Date {
            if let _date = _date {
                return _date
            } else {
                return .now
            }
        }
        
        var noteAsText: String {
            self.title + "\n" + self.date.formattedAsShortDate() + "\n" + self.description
        }
        
        enum CodingKeys: String, CodingKey {
            case _id = "id"
            case title = "todo"
            case _description
            case _date
            case isDone = "completed"
            case userId
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case notes = "todos"
    }
}
