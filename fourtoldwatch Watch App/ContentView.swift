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
    
    @State private var tabSelected: FTTabItem = .summary
    
    var body: some View {
        TabView(selection: $tabSelected) {
            HomeView()
                .tabItem {
                    Text(summaryTitle)
                }
                .tag(FTTabItem.summary)
            
            RestView()
                .tabItem {
                    Text(restTitle)
                }
                .tag(FTTabItem.rest)
        }
        .tabViewStyle(.verticalPage)
    }
}

#Preview {
    let hkController = HKController()
    hkController.stepCountToday = 10000
    hkController.stepCountWeek = 6500
    hkController.mindfulMinutesToday = 20
    hkController.mindfulMinutesWeek = 60
    hkController.zone2Today = 15
    hkController.zone2Week = 75
    
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
