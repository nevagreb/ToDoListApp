//
//  CoreDataExtensions.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 02.02.2025.
//

import CoreData

extension NSManagedObjectContext {
    // функция используется для сокращения
    // кода для сохранения изменения МОК
    func saveContext() {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // функция создания новой заметки
    func addNewNote() -> ToDoNote {
        let newNote = ToDoNote(context: self)
        newNote.createEmptyNote()
        saveContext()
        return newNote
    }
    
    // функция добавления в МОК загруженных с сервера задач
    func addNotesFromServer(_ notesList: NotesList) {
        notesList.notes.forEach {
            let newNote = ToDoNote(context: self)
            newNote.addInfo(from: $0)
        }
    }
    
    // функция удаления заметки
    func delete(note: ToDoNote) {
        self.delete(note)
        saveContext()
    }
}
