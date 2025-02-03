//
//  ToDoList.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import Foundation

// класс - ViewModel для списка задач
final class ToDoList: ObservableObject {
    @Published var notesList: NotesList
    @Published var router: Router
    @Published var isFetching: Bool
    
    init(router: Router) {
        self.notesList = NotesList()
        self.router = router
        self.isFetching = false
    }
    
    // MARK: - Intent(s)
    // функции загрузки с сервера 
    @MainActor
    func featchData() async {
        isFetching = true
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(NotesList.self, from: data) {
                self.notesList = decodedResponse
                self.isFetching = false
            }
        } catch {
            print("Invalid data")
        }
    }
}

// функции навигации
extension ToDoList {
    // функция перехода к детальному виду
    func navigate(to note: ToDoNote) {
        router.navigate(to: note)
    }
    
    // функция возврата к списку задач
    func goBack() {
        router.goBack()
    }
}
