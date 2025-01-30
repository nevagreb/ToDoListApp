//
//  ToDoView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 28.01.2025.
//

import SwiftUI
// структура - детальный экран заметки
struct NoteView: View {
    let note: NotesList.Note?
    @EnvironmentObject var toDoList: ToDoList
    @State private var title: String = ""
    @State private var description: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(Const.Layout.titlePlaceHolder, text: $title)
                .font(Const.Text.boldFont)
                .padding(.bottom, Const.Layout.largePadding)
            Text(note?.date.formattedAsShortDate() ?? Date.now.formattedAsShortDate())
                .font(Const.Text.bodyFont)
                .opacity(0.5)
                .padding(.bottom, Const.Layout.largePadding)
            noteText
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            fetch()
        }
        .onDisappear {
            if isNoteEmpty {
                delete()
            } else {
                save()
            }
        }
    }
    
    // текст эдитор для текста заметки с кастомным плэйсхолдером
    private var noteText: some View {
        ZStack (alignment: .topLeading) {
            if description.isEmpty {
                Text(Const.Layout.descriptionPlaceHolder)
                    .foregroundColor(Color(uiColor: .placeholderText))
            }
            TextEditor(text: $description)
                .opacity(description.isEmpty ? 0.1 : 1)
        }
        .font(Const.Text.titleFont)
    }
    
    // кастомная кнопка возвращения назад
    private var backButton: some View {
        Button(action: { toDoList.goBack() }) {
            HStack {
                Image(Const.Icons.back)
                Text(Const.Layout.backButtonTitle)
                    .foregroundStyle(.yellow)
            }
        }
    }
    
    // проверка на пустоту полей после редактирования
    private var isNoteEmpty: Bool {
        title.isEmpty && description.isEmpty
    }
    
    // загрузка данных задачи
    private func fetch() {
        if let note = note {
            title = note.title
            description = note.description
        }
    }
    
    // функция сохранения изменений
    private func save() {
        toDoList.save(at: note?.id, with: title, description)
    }
    
    // функция удаления задачи
    private func delete() {
        if let note = note {
            toDoList.delete(with: note.id)
        }
    }
}
