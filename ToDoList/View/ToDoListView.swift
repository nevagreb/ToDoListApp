//
//  ContentView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

// структура - вью списка задач
struct ToDoListView: View {
    @EnvironmentObject var presenter: Presenter
    
    @State private var searchText = ""
    @State var shareText: ShareText?
    
    var body: some View {
        VStack {
            if presenter.isFetching {
                ProgressView()
                Spacer()
            } else {
                listOfToDos
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomBar
        }
        .navigationTitle(Const.Layout.titleText)
        .searchable(text: $searchText,
                    placement: .toolbar)
        
        .keyboardType(.alphabet)
        .disableAutocorrection(true)
        .onChange(of: searchText) { newValue in
            presenter.updateQuery(newValue)
        }
        .sheet(item: $shareText,
               content: { shareText in ActivityView(text: shareText.text) })
        .onAppear {
            Task {
                await presenter.loadNotesIfNeeded()
            }
        }
    }
    
    // список задач
    private var listOfToDos: some View {
        ScrollView {
            LazyVStack {
                ForEach(presenter.notes) { note in
                    ToDoRowView(note: note,
                                shareAction: { share(note) })
                    .onTapGesture(count: 1) {
                        presenter.navigate(to: note)
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
                Text(presenter.notes.count.numberToStingInTasks())
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
            let newNote = presenter.addNewNote()
            presenter.navigate(to: newNote)
        }
    }
    
    // функция поделиться задачей
    private func share(_ note: ToDoNote) {
        let sharedText = note.title + "\n" + note.date.formattedAsShortDate() + "\n" + note.text
        shareText = ShareText(text: sharedText)
    }
}

