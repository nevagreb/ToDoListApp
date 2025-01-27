//
//  Constants.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// параметры верстки
enum Const {
    enum Text {
        static let titleFont = Font.system(size: 16)
        static let bodyFont = Font.system(size: 12)
    }
    enum Layout {
        static let title: String = "Задачи"
        static let padding: CGFloat = 6
    }
    enum Colors {
        static let backgroundColor = Color.customGray
    }
    enum Icons {
        static let newNote: String = "newNote"
        static let selectedCheckmark: String = "checkmarkYellow"
        static let unselectedCheckmark: String = "circle"
    }
}
