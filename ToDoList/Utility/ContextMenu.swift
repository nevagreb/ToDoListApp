//
//  Axullary.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 28.01.2025.
//

import SwiftUI

// структура - контекстное меню 
struct ContexMenuButton: View {
    let type: ContexMenuButtonType
    let action: ()->Void
    
    var body: some View {
        Button(role: type == .delete ? .destructive : nil,
               action: action,
               label: { label })
    }
    
    var label: some View {
        HStack {
            Text(type.getTitle())
                .foregroundColor(type == .delete ? .red : .black)
            Spacer()
            Image(type.getIcon())
        }
    }
}
