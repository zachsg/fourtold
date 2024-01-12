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

    @State private var tagSheetIsShowing = false
    @State private var zone2TodayPercent = 0.0
    @State private var zone2WeekPercent = 0.0
    
    var body: some View {
        NavigationStack {
            List {
                Section("Progress") {
                    StatRow(headerImage: vO2SystemImage, headerTitle: "Latest cardio fitness", date: healthKitController.latestCardioFitness, stat: healthKitController.cardioFitnessMostRecent, color: .sweat, units: vO2Units) {
                        VO2Chart(healthKitController: healthKitController)
                    } badge: {
                        VO2Badge(healthKitController: healthKitController)
                    }

                    StatRow(headerImage: vO2SystemImage, headerTitle: "Latest resting heart rate", date: healthKitController.latestRhr, stat: Double(healthKitController.rhrMostRecent), color: .sweat, units: heartUnits) {
                        RHRChart(healthKitController: healthKitController)
                    } badge: {
                        RHRBadge(healthKitController: healthKitController)
                    }

                    StatRow(headerImage: vO2SystemImage, headerTitle: "Latest cardio recovery", date: healthKitController.latestRecovery, stat: Double(healthKitController.recoveryMostRecent), color: .sweat, units: heartUnits) {
                        RecoveryChart(healthKitController: healthKitController)
                    } badge: {
                        RecoveryBadge(healthKitController: healthKitController)
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
        healthKitController.getRhrRecent(refresh: hard)
        healthKitController.getRecoveryRecent(refresh: hard)

        healthKitController.getZone2Today(refresh: hard)
        healthKitController.getZone2Week(refresh: hard)
    }
}

#Preview {
    let healthKitController = HealthKitController()

    let today: Date = .now

    healthKitController.cardioFitnessMostRecent = 45
    healthKitController.cardioFitnessAverage = 43
    for i in 0...30 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.cardioFitnessByDay[date] = Double.random(in: 40...45)
        }
    }

    healthKitController.rhrMostRecent = 60
    healthKitController.rhrAverage = 63
    for i in 0...30 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.rhrByDay[date] = Int.random(in: 60...70)
        }
    }

    healthKitController.recoveryMostRecent = 32
    healthKitController.recoveryAverage = 30
    for i in 0...30 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.recoveryByDay[date] = Int.random(in: 28...33)
        }
    }

    return SweatView(healthKitController: healthKitController)
}
