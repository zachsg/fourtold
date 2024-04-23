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
                ReadSheet(healthKitController: healthKitController, showingSheet: $readSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $journalSheetIsShowing) {
                JournalSheet()
            }
            .sheet(isPresented: $breathworkSheetIsShowing) {
                BreathSheet(healthKitController: healthKitController, showingSheet: $breathworkSheetIsShowing)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $meditateSheetIsShowing) {
                MeditationsSheet(healthKitController: healthKitController, showingSheet: $meditateSheetIsShowing)
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
    
    return RestView()
        .environment(healthKitController)
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self, FTTag.self, FTTagOption.self], inMemory: true)
}
