//
//  ToDoNote+CoreDataProperties.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 02.02.2025.
//
//

import Foundation
import CoreData


extension ToDoNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoNote> {
        return NSFetchRequest<ToDoNote>(entityName: "ToDoNote")
    }

    @NSManaged public var wrappedDate: Date?
    @NSManaged public var wrappedId: UUID?
    @NSManaged public var wrappedIsDone: Bool
    @NSManaged public var wrappedText: String?
    @NSManaged public var wrappedTitle: String?
    @NSManaged public var wrappedUserId: Int16

}

// расширение используется для вычисления не Optional
// переменных для работы в UI
extension ToDoNote : Identifiable {
    public var id: UUID {
        wrappedId ?? UUID()
    }
    var title: String {
        wrappedTitle ?? ""
    }
    var text: String {
        wrappedText ?? ""
    }
    var date: Date {
        wrappedDate ?? .now
    }
    var isDone: Bool {
        wrappedIsDone
    }
    var userId: Int {
        Int(wrappedUserId)
    }
    
    // MARK: - Intent(s)
    // функция присваивает нулевые значения объекту
    func createEmptyNote() {
        self.wrappedId = UUID()
        self.wrappedTitle = ""
        self.wrappedText = ""
        self.wrappedDate = .now
        self.wrappedIsDone = false
        self.wrappedUserId = 0
    }
    
    func addInfo(from note: NotesList.Note) {
        self.wrappedId = note.id
        self.wrappedTitle = note.title
        self.wrappedText = note.description
        self.wrappedDate = note.date
        self.wrappedIsDone = note.isDone
        self.wrappedUserId = Int16(note.userId)
    }
}
