//
//  ContentView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// структура - вью списка задач
struct ToDoListView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.wrappedTitle)])
        var todos: FetchedResults<ToDoNote>
    
    @EnvironmentObject var toDoList: ToDoList
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var searchText = ""
    @State var shareText: ShareText?

    var body: some View {
        VStack {
//            if toDoList.isFetching {
//                ProgressView()
//                Spacer()
//            } else {
                listOfToDos
                    .searchable(text: $searchText,
                                placement: .toolbar)
            //}
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
                ForEach(todos) { note in
                    ToDoRowView(note: note,
                                shareAction: { share(note) })
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
                Text(todos.count.numberToStingInTasks())
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
            Button(action: addNote) {
                Image(Const.Icons.newNote)
            }
        }
    }
    
    private func addNote() {
        withAnimation {
            let newNote = ToDoNote(context: managedObjectContext)
            newNote.createEmptyNote()
            managedObjectContext.saveContext()
            toDoList.navigate(to: newNote)
        }
    }
    
    // функция поделиться задачей
    private func share(_ note: ToDoNote) {
        let sharedText = note.title + "\n" + note.date.formattedAsShortDate() + "\n" + note.description
        shareText = ShareText(text: sharedText)
    }
}

