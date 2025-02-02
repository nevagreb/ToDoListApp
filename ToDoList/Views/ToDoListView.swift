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
        VStack {
            if toDoList.isFetching {
                ProgressView()
                Spacer()
            } else {
                listOfToDos
                    .searchable(text: $searchText,
                                placement: .toolbar)
            }
        }
        .navigationTitle(Const.Layout.titleText)
        .safeAreaInset(edge: .bottom) {
            bottomBar
        }
        .sheet(item: $shareText,
               content: { shareText in ActivityView(text: shareText.text) })
    }
    
    // список задач
    private var listOfToDos: some View {
        ScrollView {
            LazyVStack {
                ForEach(toDoList.notes, id: \.id) { note in
                    ToDoRowView(note: note,
                                shareAction: { share(with: note.id) })
                    .onTapGesture(count: 1) {
                        toDoList.navigate(to: note)
                    }
                }
            }
        }
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
    
    // функция поделиться задачей
    private func share(with id: UUID) {
        shareText = ShareText(text: toDoList.returnNoteAsText(with: id))
    }
}

