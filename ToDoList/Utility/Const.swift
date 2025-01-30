//
//  Constants.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// константы
// параметры верстки
enum Const {
    enum Text {
        static let titleFont = Font.system(size: 16)
        static let bodyFont = Font.system(size: 12)
        static let boldFont = Font.system(size: 34, weight: .bold)
    }
    
    enum Layout {
        static let titleText: String = "Задачи"
        static let titlePlaceHolder: String = "Название заметки"
        static let descriptionPlaceHolder: String = "Введите текст заметки"
        static let backButtonTitle: String = "Назад"
        static let largePadding: CGFloat = 8
        static let padding: CGFloat = 6
    }
    
    enum Colors {
        static let backgroundColor = Color.customGray
    }
    
    enum Icons {
        static let newNote: String = "newNote"
        static let selectedCheckmark: String = "checkmarkYellow"
        static let unselectedCheckmark: String = "circle"
        static let back: String = "chevron"
    }
}
