//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Kristina Grebneva on 27.01.2025.
//

import SwiftUI

@main
struct ToDoListApp: App {
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            HomeScreen(router: router)
                .preferredColorScheme(.dark)
        }
    }
}
