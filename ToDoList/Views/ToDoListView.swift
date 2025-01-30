//
//  ContentView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// структура - вью списка задач
struct ToDoListView: View {
    @EnvironmentObject var toDoList: ToDoList
    @State private var searchText = ""
    @State var shareText: ShareText?
    
    var body: some View {
        listOfToDos
            .navigationTitle(Const.Layout.titleText)
            .safeAreaInset(edge: .bottom) {
                bottomBar
            }
            .sheet(item: $shareText, 
                   content: { shareText in ActivityView(text: shareText.text) })
            .searchable(text: $searchText,
                        placement: .toolbar)
    }
    
    // список задач
    private var listOfToDos: some View {
        List {
            ForEach(toDoList.notes) { note in
                ToDoRowView(note: note,
                            tapAction: { markAsDone(with: note.id) })
                .onTapGesture(count: 1) {
                    toDoList.navigate(to: note)
                }
                .contextMenu {
                    ContexMenuButton(type: .edit,
                                     action: { toDoList.navigate(to: note) })
                    ContexMenuButton(type: .share,
                                     action: { share(with: note.id) })
                    ContexMenuButton(type: .delete,
                                     action: { toDoList.delete(with: note.id) })
                }
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
            Button(action: toDoList.navigateToNew) {
                Image(Const.Icons.newNote)
            }
        }
    }
    
    // функция выбора задачи
    private func markAsDone(with id: UUID) {
        toDoList.markAsDone(with: id)
    }
    
    // функция поделиться задачей
    private func share(with id: UUID) {
        shareText = ShareText(text: toDoList.returnNoteAsText(with: id))
    }
}

