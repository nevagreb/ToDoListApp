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
    // контекст для работы с UI
    private var mainContext: NSManagedObjectContext
    // контекст для фоновых операций
    private var backgroundContext: NSManagedObjectContext
    @Published var notes: [ToDoNote] = []
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.parent = context
        publish()
    }
    
    // функция фетчинга данных из CoreData
    private func allNotes() -> [ToDoNote] {
        var fetchedNotes: [ToDoNote] = []
        let fetchRequest: NSFetchRequest<ToDoNote> = ToDoNote.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "wrappedDate", ascending: false)]
        
        // выполнение запроса в фоновом потоке
        backgroundContext.performAndWait {
            do {
                fetchedNotes = try self.backgroundContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("\(error), \(error.userInfo)")
            }
        }
        return fetchedNotes
    }
    
    // функция сохранения
    private func save() {
        // выполнение сохранения в фоновом потоке
        backgroundContext.perform {
            do {
                try self.backgroundContext.save()
                // перенос изменений в основной контекст
                self.mainContext.perform {
                    do {
                        try self.mainContext.save()
                        self.publish()
                    } catch {
                        print("Ошибка сохранения в mainContext: \(error)")
                    }
                }
            } catch let error as NSError {
                print("\(error), \(error.userInfo)")
            }
        }
    }
    
    // функция удаления всех заметок
    func removeAllNotes() {
        // выполнение удаления в фоновом потоке
        backgroundContext.performAndWait {
            self.allNotes().forEach { object in
                self.backgroundContext.delete(object)
            }
            self.save()
        }
    }
    
    // функция обновления массива
    private func publish() {
        notes = allNotes()
    }
    
    // создание паблишера
    var notesPublisher: Published<[ToDoNote]>.Publisher { $notes }
    
    // функция создания новой задачи
    func addNewNote() -> ToDoNote {
        var newNote: ToDoNote!
        // выполнение в фоновом потоке
        backgroundContext.performAndWait {
            newNote = self.backgroundContext.addNewNote()
            self.save()
        }
        
        return newNote
    }
    
    // функция удаления задачи
    func delete(_ note: ToDoNote) {
        // выполнение удаления в фоновом потоке
        backgroundContext.performAndWait {
            self.backgroundContext.delete(note)
            self.save()
        }
    }
    
    // функция добавления в МОК загруженных с сервера задач
    func addNotesFromServer(_ notesList: NotesList) {
        // выполнение в фоновом потоке
        backgroundContext.performAndWait {
            notesList.notes.forEach {
                let newNote = ToDoNote(context: self.backgroundContext)
                newNote.addInfo(from: $0)
            }
            self.save()
        }
    }
    
    // функция отметки задачи как выполненной
    func markAsDone(_ note: ToDoNote) {
        // выполнение в фоновом потоке
        backgroundContext.performAndWait {
            note.wrappedIsDone.toggle()
            self.save()
        }
    }
    
    // функция редактирования задачи
    func edit(_ note: ToDoNote, title: String, description: String) {
        // выполнение редактирования в фоновом потоке
        backgroundContext.performAndWait {
            note.wrappedTitle = title
            note.wrappedText = description
            self.save()
        }
    }
    
    // функция добавления в CoreData задач, загруженных с сервера
    func fetchNotes(query: String?) {
        // добавление задач в фоновом потоке
        backgroundContext.performAndWait {
            do {
                let fetchRequest: NSFetchRequest<ToDoNote> = ToDoNote.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "wrappedDate", ascending: false)]
                
                if let query = query, !query.isEmpty {
                    let p1 = NSPredicate(format: "wrappedTitle CONTAINS[cd] %@", query)
                    let p2 = NSPredicate(format: "wrappedText CONTAINS[cd] %@", query)
                    fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [p1, p2])
                }
                
                self.notes = try self.backgroundContext.fetch(fetchRequest)
            } catch {
                print("Ошибка загрузки данных: \(error)")
                self.notes = []
            }
        }
    }
}
