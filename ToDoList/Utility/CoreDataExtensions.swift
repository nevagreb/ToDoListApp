//
//  CoreDataExtensions.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 02.02.2025.
//

import CoreData
// расширение используется для сокращения
// кода для сохранения изменения МОК
extension NSManagedObjectContext {
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
}
