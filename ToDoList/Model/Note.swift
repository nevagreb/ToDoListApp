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
