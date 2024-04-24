//
//  SweatView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 4/24/24.
//

import SwiftUI

struct SweatView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(HKController.self) private var hkController
    
    @AppStorage(dailyZone2GoalKey) var dailyZone2Goal: Int = dailyZone2GoalDefault

    @State private var zone2TodayPercent = 0.0
    @State private var zone2WeekPercent = 0.0
    
    var body: some View {
        NavigationStack {
            List {
                Section("Progress") {
                    StatRow(headerImage: vO2SystemImage, headerTitle: "Latest cardio fitness", date: hkController.latestCardioFitness, stat: hkController.cardioFitnessMostRecent, color: .sweat, units: vO2Units) {
                        VO2Chart()
                    } badge: {
                        VO2Badge()
                    }

                    StatRow(headerImage: vO2SystemImage, headerTitle: "Latest resting heart rate", date: hkController.latestRhr, stat: Double(hkController.rhrMostRecent), color: .sweat, units: heartUnits) {
                        RHRChart()
                    } badge: {
                        RHRBadge()
                    }

                    StatRow(headerImage: vO2SystemImage, headerTitle: "Latest cardio recovery", date: hkController.latestRecovery, stat: Double(hkController.recoveryMostRecent), color: .sweat, units: heartUnits) {
                        RecoveryChart()
                    } badge: {
                        RecoveryBadge()
                    }
                }

                Section("Activity") {
                    StatRow(headerImage: vO2SystemImage, headerTitle: "Zone 2 today", date: hkController.latestZone2, stat: Double(hkController.zone2Today), color: .sweat, goal: dailyZone2Goal / 60, units: "min")
                    
                    StatRow(headerImage: vO2SystemImage, headerTitle: "Zone 2 past 7 days", date: hkController.latestZone2, stat: Double(hkController.zone2Week), color: .sweat, goal: (dailyZone2Goal * 7) / 60, units: "min", destination: {
                        WeekZone2DetailView()
                    })
                }
            }
            .navigationTitle(sweatTitle)
            .onAppear(perform: {
                refresh()
            })
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    refresh()
                }
            }
            .refreshable {
                refresh()
            }
        }
    }
    
    private func refresh() {
        hkController.getCardioFitnessRecent()
        hkController.getRhrRecent()
        hkController.getRecoveryRecent()

        hkController.getZone2Today()
        hkController.getZone2Week()
        hkController.getZone2Recent()
    }
}

#Preview {
    let hkController = HKController()

    let today: Date = .now

    hkController.cardioFitnessMostRecent = 45
    hkController.cardioFitnessAverage = 43
    for i in 0...30 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            hkController.cardioFitnessByDay[date] = Double.random(in: 40...45)
        }
    }

    for i in 0...30 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            hkController.zone2ByDay[date] = Int.random(in: 0...45)
        }
    }

    hkController.rhrMostRecent = 60
    hkController.rhrAverage = 63
    for i in 0...30 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            hkController.rhrByDay[date] = Int.random(in: 60...70)
        }
    }

    hkController.recoveryMostRecent = 32
    hkController.recoveryAverage = 30
    for i in 0...30 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            hkController.recoveryByDay[date] = Int.random(in: 28...33)
        }
    }

    return SweatView()
        .environment(hkController)
}
