//
//  CoreDataStack.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 03.02.2025.
//

import CoreData
import Combine

// класс для управления взаимодействием с CoreData
class CoreDataStack: ObservableObject {
    private var managedObjectContext: NSManagedObjectContext
    @Published var notes: [ToDoNote] = []
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        publish()
    }
    
    // функция фетчинга данных из CoreData
    private func allNotes() -> [ToDoNote] {
        do {
            let fetchRequest : NSFetchRequest<ToDoNote> = ToDoNote.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "wrappedDate", ascending: false)]
            return try self.managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return []
        }
    }
    
    // функция сохранения
    private func save() {
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
        publish()
    }
    
    // функция удаления всех заметок
    func removeAllNotes() {
        allNotes().forEach { object in managedObjectContext.delete(object) }
        save()
    }
    
    // функция обновления массива
    private func publish() {
        notes = allNotes()
    }
    
    // создание паблишера
    var notesPublisher: Published<[ToDoNote]>.Publisher { $notes }
    
    // функция создания новой задачи
    func addNewNote() -> ToDoNote {
        let note = managedObjectContext.addNewNote()
        save()
        return note
    }
    
    // функция удаления задачи
    func delete(_ note: ToDoNote) {
        managedObjectContext.delete(note: note)
        save()
    }
    
    // функция добавления в МОК загруженных с сервера задач
    func addNotesFromServer(_ notesList: NotesList) {
        notesList.notes.forEach {
            let newNote = ToDoNote(context: managedObjectContext)
            newNote.addInfo(from: $0)
        }
        save()
    }
    
    // функция отметки задачи как выполненной
    func markAsDone(_ note: ToDoNote) {
        note.wrappedIsDone.toggle()
        save()
    }
    
    // функция редактирования задачи
    func edit(_ note: ToDoNote, title: String, description: String) {
        note.wrappedTitle = title
        note.wrappedText = description
        save()
    }
    
    // функция добавления в CoreData задач, загруженных с сервера
    func fetchNotes(query: String?) {
        do {
            let fetchRequest: NSFetchRequest<ToDoNote> = ToDoNote.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "wrappedDate", ascending: false)]
            
            if let query = query, !query.isEmpty {
                let p1 = NSPredicate(format: "wrappedTitle CONTAINS[cd] %@", query)
                let p2 = NSPredicate(format: "wrappedText CONTAINS[cd] %@", query)
                fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [p1, p2])
            }
            
            self.notes = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Ошибка загрузки данных: \(error)")
            self.notes = []
        }
    }
}
