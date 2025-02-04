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
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            HomeScreen(router: router, dataModel: CoreDataStack(context: persistenceController.container.viewContext))
                .preferredColorScheme(.dark)
        }
        // сохранение при изменении scenePhase
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
