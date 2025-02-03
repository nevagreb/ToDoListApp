//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Kristina Grebneva on 03.02.2025.
//

import XCTest
@testable import ToDoList

// тестирование класса ToDoList
final class ToDoListTests: XCTestCase {
    
    var toDoList: ToDoList!
    var testRouter: TestRouter!

    override func setUp() {
        super.setUp()
        // фэйковый роутер для тестирования
        testRouter = TestRouter()
        toDoList = ToDoList(router: testRouter)
    }
    
    override func tearDown() {
        toDoList = nil
        testRouter = nil
        super.tearDown()
    }
    
    // инициализация
    func testInitToDoList() {
        XCTAssertNotNil(toDoList.notesList)
        XCTAssertNotNil(toDoList.router)
        XCTAssertFalse(toDoList.isFetching)
    }
    
    // навигация к задаче
    func testNavigateToNote() {
        let testNote = ToDoNote()
        toDoList.navigate(to: testNote)
        
        XCTAssertEqual(testRouter.lastNavigatedNote, testNote)
    }
    
    // возврат к списку
    func testGoBack() {
        toDoList.goBack()
        XCTAssertTrue(testRouter.didGoBack)
    }
    
    // имитация запроса на сервер
    func testFetchData() async {
        XCTAssertFalse(toDoList.isFetching)
        
        await toDoList.featchData()
        
        XCTAssertFalse(toDoList.isFetching)
        XCTAssertFalse(toDoList.notesList.notes.isEmpty)
    }
}

// фэйковый роутер для тестирования
final class TestRouter: Router {
    var lastNavigatedNote: ToDoNote?
    var didGoBack = false
    
    override func navigate(to note: ToDoNote) {
        lastNavigatedNote = note
    }
    
    override func goBack() {
        didGoBack = true
    }
}
