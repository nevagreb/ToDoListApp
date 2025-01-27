//
//  Extensions.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// Возвращает дату в формате "dd/MM/yy"
extension Date {
    func formattedAsShortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: self)
    }
}

// Преобразование числа в строку с добавлением
// слова "Задача"
extension Int {
    func numberToStingInTasks() -> String {
        let lastDigit = self % 10
        let lastTwoDigits = self % 100
        
        if (11...19).contains(lastTwoDigits) {
            return "\(self) Задач"
        }
        
        switch lastDigit {
        case 1:
            return "\(self) Задача"
        case 2...4:
            return "\(self) Задачи"
        default:
            return "\(self) Задач"
        }
    }
}
// extension используется для иницииализации цвета
// по шестнадцатеричному коду (hex)
extension Color {
    static let customGray = Color(hex: "#272729")
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
