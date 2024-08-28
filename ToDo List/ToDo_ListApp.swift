//
//  ToDo_ListApp.swift
//  ToDo List
//
//  Created by Алексей Азаренков on 23.08.2024.
//

import SwiftUI

@main
struct ToDo_ListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Router.createModule()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
