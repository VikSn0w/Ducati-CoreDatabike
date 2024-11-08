//
//  Ducati_CoreDatabikeApp.swift
//  Ducati-CoreDatabike
//
//  Created by Vittorio Picone on 22/10/24.
//

import SwiftUI

@main
struct CoreDucati: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
