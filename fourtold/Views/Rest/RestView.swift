//
//  RestView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftData
import SwiftUI

struct RestView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(HealthKitController.self) private var healthKitController
    
    @State private var meditateSheetIsShowing = false
    @State private var breathworkSheetIsShowing = false
    @State private var journalSheetIsShowing = false
    @State private var readSheetIsShowing = false
    @State private var lastDate: Date = .now
    @State private var showOldActivities = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section {
                        RestMinutes()
                        RestStreaks()
                    } header: {
                        Text("Stats")
                    }

                    RestTodayActivities()

                    RestOldActivities(showOldActivities: $showOldActivities)
                    
                    Section {
                    } footer: {
                        Rectangle()
                            .frame(width: 0, height: 0)
                            .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle(restTitle)
            .toolbar {
                ToolbarItemGroup {
                    Button(journalTitle, systemImage: journalSystemImage) {
                        journalSheetIsShowing.toggle()
                    }
                    .tint(.rest)
                    
                    Button(readTitle, systemImage: readSystemImage) {
                        readSheetIsShowing.toggle()
                    }
                    .tint(.rest)
                    
                    Button(breathTitle, systemImage: breathSystemImage) {
                        breathworkSheetIsShowing.toggle()
                    }
                    .tint(.rest)
                    
                    Button(meditateTitle, systemImage: meditateSystemImage) {
                        meditateSheetIsShowing.toggle()
                    }
                    .tint(.rest)
                }
            }
            .sheet(isPresented: $readSheetIsShowing) {
                ReadSheet(showingSheet: $readSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $journalSheetIsShowing) {
                JournalSheet()
            }
            .sheet(isPresented: $breathworkSheetIsShowing) {
                BreathSheet(showingSheet: $breathworkSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $meditateSheetIsShowing) {
                MeditationsSheet(showingSheet: $meditateSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    if !Calendar.current.isDateInToday(lastDate) {
                        lastDate = .now
                        showOldActivities.toggle()
                        showOldActivities = false
                    }
                }
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTMeditate.self,
            FTRead.self,
            FTBreath.self,
            FTTag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            let meditation = FTMeditate(startDate: .now, timeOfDay: .morning, startMood: .neutral, endMood: .pleasant, type: .timed, duration: 300)
            
            container.mainContext.insert(meditation)
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return RestView()
        .environment(healthKitController)
        .modelContainer(sharedModelContainer)
}
