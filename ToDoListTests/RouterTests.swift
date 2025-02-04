//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Kristina Grebneva on 03.02.2025.
//

import XCTest
@testable import ToDoList

// тестирование класса Router
final class RouterTests: XCTestCase {
    
    var router: Router!
    
    override func setUp() {
        super.setUp()
        router = Router()
    }
    
    override func tearDown() {
        router = nil
        super.tearDown()
    }
    
    // проверка начального состояния роутера
    func testInitialScreen() {
        XCTAssertEqual(router.currentScreen, Router.Screen.toDoList)
    }
    
    // проверка перехода на детальный экран задачи
    func testNavigateToNote() {
        let testNote = ToDoNote()
        
        router.navigate(to: testNote)
        
        switch router.currentScreen {
        case .toDoList:
            XCTFail("Navigation failed, still on toDoList screen")
        case .toDo(let note):
            XCTAssertEqual(note, testNote)
        }
    }
    
    // проверка возврата на экран списка задач
    func testGoBack() {
        let testNote = ToDoNote()
        
        // Переходим на детальный экран
        router.navigate(to: testNote)
        
        // Возвращаемся назад
        router.goBack()
        
        XCTAssertEqual(router.currentScreen, Router.Screen.toDoList)
    }
}
