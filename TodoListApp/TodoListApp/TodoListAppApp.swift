//
//  TodoListAppApp.swift
//  TodoListApp
//
//  Created by Dineth Dissanayake on 2023-03-20.
//

import SwiftUI

@main
struct TodoListAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
