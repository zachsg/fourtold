//
//  SweatView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/3/24.
//

import SwiftUI

struct SweatView: View {
    @Environment(\.scenePhase) var scenePhase
    @Bindable var healthKitController: HealthKitController
    
    @AppStorage(dailyZone2GoalKey) var dailyZone2Goal: Int = dailyZone2GoalDefault
    @AppStorage(hasVO2Key) var hasVO2: Bool = hasVO2Default

    @State private var tagSheetIsShowing = false
    @State private var zone2TodayPercent = 0.0
    @State private var zone2WeekPercent = 0.0
    
    var body: some View {
        NavigationStack {
            List {
                Section("Progress") {
                    if hasVO2 {
                        StatRow(headerImage: vO2SystemImage, headerTitle: "Latest cardio fitness", date: healthKitController.latestCardioFitness, stat: healthKitController.cardioFitnessMostRecent, color: .sweat, units: vO2Title, badge: {
                            VO2Badge(healthKitController: healthKitController)
                        })
                    }
                }

                Section("Activity") {
                    StatRow(headerImage: vO2SystemImage, headerTitle: "Zone 2 today", date: healthKitController.latestZone2, stat: Double(healthKitController.zone2Today), color: .sweat, goal: dailyZone2Goal / 60, units: "min")
                    
                    StatRow(headerImage: vO2SystemImage, headerTitle: "Zone 2 past 7 days", date: healthKitController.latestZone2, stat: Double(healthKitController.zone2Week), color: .sweat, goal: (dailyZone2Goal * 7) / 60, units: "min", destination: {
                        WeekZone2DetailView(healthKitController: healthKitController)
                    })
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
            .onAppear(perform: {
                if healthKitController.zone2Week == 0 {
                    refresh(hard: true)
                } else {
                    refresh()
                }
            })
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    let today = Calendar.current.isDateInToday(healthKitController.latestZone2)
                    refresh(hard: !today)
                }
            }
            .refreshable {
                refresh()
            }
        }
    }
    
    private func refresh(hard: Bool = false) {
        healthKitController.getCardioFitnessRecent(refresh: hard)
        
        healthKitController.getZone2Today(refresh: hard)
        healthKitController.getZone2Week(refresh: hard)
    }

    private func vO2Trend() -> some View {
        let vO2Average = healthKitController.cardioFitnessAverage
        let vO2Current = healthKitController.cardioFitnessMostRecent
        let trend = vO2Current.vO2Trend(given: vO2Average)

        return HStack(spacing: 0) {
            if trend == .declining {
                Text(" but ")
                Text(trend.rawValue)
                    .fontWeight(.bold)
            } else if trend == .improving {
                Text(" and ")
                Text(trend.rawValue)
                    .fontWeight(.bold)
            } else {
                Text(" and staying ")
                Text(trend.rawValue)
                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return SweatView(healthKitController: healthKitController)
}
