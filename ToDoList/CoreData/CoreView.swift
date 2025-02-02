//
//  CoreView.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 02.02.2025.
//

import SwiftUI

struct CoreView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var todos: FetchedResults<ToDoNote>
    
    var body: some View {
        List(todos) { todo in
            Text(todo.title)
        }
    }
}
