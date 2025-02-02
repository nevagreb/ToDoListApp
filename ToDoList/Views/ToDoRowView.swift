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
    let shareAction: ()->Void
    @EnvironmentObject var toDoList: ToDoList
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                // буллет
                Image(note.isDone ?
                      Const.Icons.selectedCheckmark : Const.Icons.unselectedCheckmark)
                .onTapGesture {
                    markAsDone(with: note.id)
                }
                toDo
                    .contextMenu {
                        ContexMenuButton(type: .edit,
                                         action: { toDoList.navigate(to: note) })
                        ContexMenuButton(type: .share,
                                         action: { shareAction() })
                        ContexMenuButton(type: .delete,
                                         action: { toDoList.delete(with: note.id) })
                    }
            }
            Divider()
                .overlay(.gray)
        }
        .padding(.top, Const.Layout.padding)
        .padding(.horizontal)
    }
    
    // задача
    private var toDo: some View {
        HStack {
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
                    .padding(.bottom, Const.Layout.padding)
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
    
    // функция выбора задачи
    private func markAsDone(with id: UUID) {
        toDoList.markAsDone(with: id)
    }
}

