//
//  CoreDataTest.swift
//  ToDoListTests
//
//  Created by Kristina Grebneva on 03.02.2025.
//

import XCTest
import CoreData
@testable import ToDoList

// тестирование класса CoreData
final class CoreDataTests: XCTestCase {
    
    var testPersistentContainer: NSPersistentContainer!
    var testContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        // временный контейнер
        testPersistentContainer = NSPersistentContainer(name: "ToDoNotes")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        testPersistentContainer.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Load Persistent Stores")
        testPersistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error, "Ошибка загрузки Core Data: \(String(describing: error))")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        testContext = testPersistentContainer.viewContext
    }
    
    override func tearDown() {
        testContext = nil
        testPersistentContainer = nil
        super.tearDown()
    }
    
    // тестирование создания новой задачи
    func testCreateNewNote() {
        let newNote = ToDoNote(context: testContext)
        newNote.createEmptyNote()
        testContext.saveContext()
        
        XCTAssertNotNil(newNote, "Заметка не должна быть nil")
        XCTAssertNotNil(newNote.id, "ID заметки не должен быть nil")
        XCTAssertEqual(newNote.title, "", "Заголовок должен быть пустым по умолчанию")
        XCTAssertEqual(newNote.text, "", "Текст должен быть пустым по умолчанию")
        XCTAssertFalse(newNote.isDone, "По умолчанию isDone должен быть false")
    }
    
    // тестирование сохранения задачи
    func testSaveAndFetchNote() {
        let newNote = ToDoNote(context: testContext)
        newNote.wrappedId = UUID()
        newNote.wrappedTitle = "Тестовая задача"
        newNote.wrappedText = "Описание задачи"
        newNote.wrappedIsDone = false
        newNote.wrappedDate = Date()
        newNote.wrappedUserId = 1

        testContext.saveContext()

        let fetchRequest: NSFetchRequest<ToDoNote> = ToDoNote.fetchRequest()
        do {
            let results = try testContext.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1, "Должна быть сохранена 1 задача")
            XCTAssertEqual(results.first?.title, "Тестовая задача", "Заголовок должен совпадать")
        } catch {
            XCTFail("Ошибка при выполнении запроса: \(error.localizedDescription)")
        }
    }
    
    // тестирование удаления задачи
    func testDeleteNote() {
        let newNote = ToDoNote(context: testContext)
        testContext.saveContext()
        
        testContext.delete(newNote)
        testContext.saveContext()

        let fetchRequest: NSFetchRequest<ToDoNote> = ToDoNote.fetchRequest()
        do {
            let results = try testContext.fetch(fetchRequest)
            XCTAssertEqual(results.count, 0, "Задача должна быть удалена")
        } catch {
            XCTFail("Ошибка при выполнении запроса: \(error.localizedDescription)")
        }
    }
}
