//
//  ToDoItemView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// структура - вью строки ToDo-листа
struct ToDoRowView: View {
    let note: NotesList.Note
    let tapAction: ()->Void
    
    var body: some View {
        HStack(alignment: .top) {
            // иконка
            Image(note.isDone ?
                  Const.Icons.selectedCheckmark : Const.Icons.unselectedCheckmark)
            .onTapGesture {
                tapAction()
            }
            
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
                .opacity(note.isDone ? 0.5 : 1)
                // дата форматированная в краткую
                Text(note.date.formattedAsShortDate())
                    .font(Const.Text.bodyFont)
                    .opacity(0.5)
            }
            Spacer()
        }
        // используется для того, чтобы сделать всю
        // область HStack кликабельной
        .contentShape(Rectangle())
    }
    
    // функция создания перечеркнутого текста
    // модификатор .strikethrough(note.isSelected) работает в IOS 16 и выше,
    // для создания перечеркнутого текста используется AttributedString
    private func attributedTitle(of note: NotesList.Note) -> AttributedString {
        var text = AttributedString(note.title)
        if note.isDone {
            text.strikethroughStyle = .single
            text.strikethroughColor = .gray
        }
        return text
    }
}

