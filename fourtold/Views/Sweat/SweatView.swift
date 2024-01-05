//
//  SweatView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/3/24.
//

import SwiftUI

struct SweatView: View {
    @Bindable var healthKitController: HealthKitController
    
    @AppStorage(dailyZone2GoalKey) var dailyZone2Goal: Int = dailyZone2GoalDefault
    
    @State private var tagSheetIsShowing = false
    @State private var zone2TodayPercent = 0.0
    @State private var zone2WeekPercent = 0.0
    
    var body: some View {
        NavigationStack {
            List {
                Section("Progress") {
                    StatRow(headerImage: vO2SystemImage, headerTitle: "Lasest cardio fitness", date: healthKitController.latestCardioFitness, stat: healthKitController.cardioFitnessMostRecent, color: .sweat)
                }
                
                Section("Activity") {
                    StatRow(headerImage: vO2SystemImage, headerTitle: "Zone 2 today", date: healthKitController.latestZone2, stat: Double(healthKitController.zone2Today), color: .sweat, goal: dailyZone2Goal / 60, units: "min")
                    
                    StatRow(headerImage: vO2SystemImage, headerTitle: "Zone 2 past 7 days", date: healthKitController.latestZone2, stat: Double(healthKitController.zone2Week), color: .sweat, goal: (dailyZone2Goal * 7) / 60, units: "min") {
                        WeekZone2DetailView(healthKitController: healthKitController)
                    }
                }
                
                TagsTodayView()
                
                TagsOldView(color: .sweat)
            }
            .navigationTitle(sweatTitle)
            .toolbar {
                ToolbarItem {
                    Button(tagTitle, systemImage: tagSystemImage) {
                        tagSheetIsShowing.toggle()
                    }
                    .tint(.sweat)
                }
            }
            .sheet(isPresented: $tagSheetIsShowing) {
                TagSheet(showingSheet: $tagSheetIsShowing, color: .sweat)
                    .interactiveDismissDisabled()
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return SweatView(healthKitController: healthKitController)
}
