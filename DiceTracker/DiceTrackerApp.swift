//
//  DiceTrackerApp.swift
//  DiceTracker
//
//  Created by Andrew Ingraham on 11/16/23.
//

// Swift replacement for AppDelegate ?
// Main, everything starts here

import SwiftUI
@main
struct DiceTrackerApp: App {
    
    @StateObject var dataController = DataController()
    @State private var errorWrapper: ErrorWrapper?
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            MenuView().environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
