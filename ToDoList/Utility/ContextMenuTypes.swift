//
//  ContextMenuTypes.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 28.01.2025.
//

import Foundation

// константы
// enum - данные контекстного меню
enum ContexMenuButtonType {
    case edit
    case share
    case delete
    
    func getTitle() -> String {
        switch self {
        case .edit:
           return "Редактировать"
        case .share:
            return "Поделиться"
        case .delete:
            return "Удалить"
        }
    }
    
    func getIcon() -> String {
        switch self {
        case .edit:
           return "edit"
        case .share:
            return "export"
        case .delete:
            return "trash"
        }
    }
}
