//
//  ToDoItemView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// структура - вью строки ToDo-листа
struct ToDoItemView: View {
    let note: NotesList.Note
    let tapAction: ()->Void
    
    var body: some View {
        HStack(alignment: .top) {
            // иконка
            Image(note.isSelected ?
                  Const.Icons.selectedCheckmark : Const.Icons.unselectedCheckmark)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    // заголовок
                    Text(attributedTitle(of: note))
                        .font(Const.Text.titleFont)
                        .padding(.bottom, Const.Layout.padding)
                    // текст задачи
                    Text(note.description)
                        .font(Const.Text.bodyFont)
                        .lineLimit(2)
                        .padding(.bottom, Const.Layout.padding)
                }
                .opacity(note.isSelected ? 0.5 : 1)
                // дата форматированная в краткую
                Text(note.date.formattedAsShortDate())
                    .font(Const.Text.bodyFont)
                    .opacity(0.5)
            }
        }
        .onTapGesture {
            tapAction()
        }
    }
    
    // функция создания перечеркнутого текста
    // модификатор .strikethrough(note.isSelected) работает в IOS 16 и выше,
    // для создания перечеркнутого текста используется AttributedString
    private func attributedTitle(of note: NotesList.Note) -> AttributedString {
        var text = AttributedString(note.title)
        if note.isSelected {
            text.strikethroughStyle = .single
            text.strikethroughColor = .gray
        }
        return text
    }
}

