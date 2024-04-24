//
//  fourtoldApp.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import SwiftData
import SwiftUI

@main
struct fourtoldApp: App {
    @State private var hkController = HKController()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTMeditate.self,
            FTRead.self,
            FTBreath.self,
            FTTag.self,
            FTTagOption.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
                .environment(hkController)
        }
    }
}
