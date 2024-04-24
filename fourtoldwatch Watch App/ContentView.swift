//
//  ContentView.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(HKController.self) private var hkController
    
    var body: some View {
        RestView()
    }
}

#Preview {
    let hkController = HKController()
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTMeditate.self,
            FTRead.self,
            FTBreath.self,
            FTTag.self,
            FTTagOption.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return ContentView()
        .modelContainer(sharedModelContainer)
        .environment(hkController)
}
