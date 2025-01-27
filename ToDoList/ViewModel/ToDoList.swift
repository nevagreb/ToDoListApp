//
//  ToDoList.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import Foundation

// класс - ViewModel для списка задач
final class ToDoList: ObservableObject {
    @Published var notesList = NotesList()
    
    // массив задач
    var notes: [NotesList.Note] {
        notesList.notes
    }
    
    // MARK: - Intent(s)
    // функция выбора элемента массива по id
    func selectNote(with id: UUID) {
        notesList.selectNote(with: id)
    }
}
