//
//  ContentView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// структура - вью списка задач
struct ToDoListView: View {
    // фетчреквест для CoreData
    @FetchRequest(sortDescriptors: [SortDescriptor(\ToDoNote.wrappedDate, order: .reverse)])
        private var todos: FetchedResults<ToDoNote>
    
    @EnvironmentObject var toDoList: ToDoList
    // 2 контекста: 1 - работа с UI, 2 - работа в фоне
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.managedObjectContext) var backgroundContext

    @State private var searchText = ""
    @State var shareText: ShareText?
    
    // свойство используется для поиска по содержимому задачи
        // и ее описания
    var query: Binding<String> {
        Binding {
            searchText
        } set: { newValue in
            let p1 = NSPredicate(format: "wrappedTitle CONTAINS %@", newValue)
            let p2 = NSPredicate(format: "wrappedText CONTAINS %@", newValue)
            searchText = newValue
            todos.nsPredicate = newValue.isEmpty
            ? nil
            : NSCompoundPredicate(orPredicateWithSubpredicates: [p1, p2])
        }
    }

    var body: some View {
        VStack {
            if toDoList.isFetching {
                ProgressView()
                Spacer()
            } else {
                listOfToDos
            }
        }
        .navigationTitle(Const.Layout.titleText)
        .searchable(text: query,
                    placement: .toolbar)
        .keyboardType(.alphabet)
        .disableAutocorrection(true)
        .safeAreaInset(edge: .bottom) {
            bottomBar
        }
        .sheet(item: $shareText,
               content: { shareText in ActivityView(text: shareText.text) })
        .task {
            if todos.isEmpty {
                await toDoList.featchData()
                addNotesFromServer()
            }
        }
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
    
    // функция создания новой заметки
    private func addNote() {
        withAnimation {
            let newNote = backgroundContext.addNewNote()
            toDoList.navigate(to: newNote)
        }
    }
    
    // функция поделиться задачей
    private func share(_ note: ToDoNote) {
        let sharedText = note.title + "\n" + note.date.formattedAsShortDate() + "\n" + note.text
        shareText = ShareText(text: sharedText)
    }
    
    // функция добавления в МОК загруженных с сервера задач
    func addNotesFromServer() {
        backgroundContext.addNotesFromServer(toDoList.notesList)
    }
}

