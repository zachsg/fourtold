//
//  RestView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftUI

struct RestView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @Bindable var healthKitController: HealthKitController
    
    @State private var meditateSheetIsShowing = false
    @State private var breathworkSheetIsShowing = false
    @State private var journalSheetIsShowing = false
    @State private var readSheetIsShowing = false
    @State private var tagSheetIsShowing = false
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
                    
                    TagsTodayView()
                    
                    RestTodayActivities()
                    
                    TagsOldView(color: .rest)
                    
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
                    Button(tagTitle, systemImage: tagSystemImage) {
                        tagSheetIsShowing.toggle()
                    }
                    .tint(.rest)
                    
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
            .sheet(isPresented: $tagSheetIsShowing) {
                TagSheet(showingSheet: $tagSheetIsShowing, color: .rest)
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
    RestView(healthKitController: HealthKitController())
}
