//
//  ContentView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// структура - вью ToDo-листа
struct ToDoListView: View {
    @StateObject private var toDoList = ToDoList()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            listOfToDos
                .navigationTitle(Const.Layout.title)
                .safeAreaInset(edge: .bottom) {
                    bottomBar
                }
        }
        .searchable(text: $searchText,
                    placement: .toolbar)
    }
    
    // список задач
    private var listOfToDos: some View {
        List {
            ForEach(toDoList.notes) { note in
                ToDoItemView(note: note,
                             tapAction: { selectNote(with: note.id) })
            }
        }
        .listStyle(.plain)
    }
    
    // боттомбар с форматированным числом задач
    private var bottomBar: some View {
        ZStack {
            HStack {
                Spacer()
                Text(toDoList.notes.count.numberToStingInTasks())
                Spacer()
            }
            newNoteButton
            
        }
        .padding()
        .background(Const.Colors.backgroundColor)
    }
    
    // кнопка добавления новой задачи
    private var newNoteButton: some View {
        HStack {
            Spacer()
            Button(action: {}) {
                Image(Const.Icons.newNote)
            }
        }
    }
    
    // функция выбора задачи
    private func selectNote(with id: UUID) {
        toDoList.selectNote(with: id)
    }
}

#Preview {
    ToDoListView()
        .preferredColorScheme(.dark)
}
