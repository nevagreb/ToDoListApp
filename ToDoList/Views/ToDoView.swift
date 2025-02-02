//
//  ToDoView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 28.01.2025.
//

import SwiftUI
// структура - детальный экран заметки
struct ToDoView: View {
    let note: ToDoNote
    @EnvironmentObject var toDoList: ToDoList
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var title: String = ""
    @State private var description: String = ""
    
    var body: some View {
        ScrollView {
            noteView
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .toolbar { keyboardDoneButton }
        .onAppear(perform: showNote)
        .onDisappear(perform: saveChanges)
    }
    
    private var noteView: some View {
        VStack(alignment: .leading) {
            TextField(Const.Layout.titlePlaceHolder, text: $title)
                .font(Const.Text.boldFont)
                .lineLimit(nil)
                .padding(.bottom, Const.Layout.largePadding)
            Text(note.date.formattedAsShortDate())
                .font(Const.Text.bodyFont)
                .opacity(0.5)
                .padding(.bottom, Const.Layout.largePadding)
            noteText
        }
        .keyboardType(.alphabet)
        .disableAutocorrection(true)
        .padding()
    }
    
    // текст эдитор для текста заметки с кастомным плэйсхолдером
    private var noteText: some View {
        ZStack (alignment: .topLeading) {
            if description.isEmpty {
                Text(Const.Layout.descriptionPlaceHolder)
                    .foregroundColor(Color(uiColor: .placeholderText))
            }
            TextEditor(text: $description)
                .lineLimit(nil)
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
    
    // кнопка Done для клавиатуры
    private var keyboardDoneButton: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(action: { hideKeyboard() }) {
                Text("Done")
                    .foregroundColor(Color.yellow)
                    .font(.body)
            }
        }
    }
    
    // проверка на пустоту полей после редактирования
    private var isNoteEmpty: Bool {
        title.isEmpty && description.isEmpty
    }
    
    // функция для отображения данных заметки на экране
    private func showNote() {
        title = note.title
        description = note.text
    }
    
    // функция сохранения изменений
    private func saveChanges() {
        if isNoteEmpty {
            delete()
        } else {
            edit()
        }
    }
    
    // функция удаления заметки
    private func delete() {
        managedObjectContext.delete(note: note)
    }
        
    // функция редактирования заметки
    private func edit() {
        withAnimation {
            note.wrappedTitle = title
            note.wrappedText = description
            managedObjectContext.saveContext()
        }
    }
}
