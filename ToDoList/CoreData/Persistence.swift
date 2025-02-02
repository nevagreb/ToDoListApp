//
//  Persistence.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 02.02.2025.
//

import CoreData

// структура - Persistence Controller
struct PersistenceController {
    // синглтон для использования контроллера
    static let shared = PersistenceController()
    // контейнер для Core Data
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "ToDoNotes")
        container.loadPersistentStores { (persistent, error) in
            if let error = error {
                fatalError("Error: " + error.localizedDescription)
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // функция созранения данных
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save")
            }
        }
    }
    
    func saveChanges(with context: NSManagedObjectContext) {
            context.performAndWait {
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        context.rollback()
                    }
                }
                context.reset()
            }
        }
}

