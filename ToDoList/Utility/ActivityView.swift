//
//  TestView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 30.01.2025.
//

import UIKit
import SwiftUI

// структура для интеграции UIActivityViewController
// ShareLink доступен в IO16 и выше
struct ActivityView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

// стуктура используется для формирования
// текста для кнопки поделиться
// нужна для соответствия протоколу Identifiable
struct ShareText: Identifiable {
    let id = UUID()
    let text: String
}
