//
//  MoveView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftUI

struct MoveView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(HealthKitController.self) private var healthKitController
    
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    var bestStepsDay: (day: Date, steps: Int) {
        var bestDay: Date = .now
        var bestSteps = 0
        
        for (day, minutes) in healthKitController.stepCountWeekByDay {
            if minutes > bestSteps {
                bestDay = day
                bestSteps = minutes
            }
        }
        
        return (bestDay, bestSteps)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    StatRow(headerImage: stepsSystemImage, headerTitle: "Steps today", date: healthKitController.latestSteps, stat: Double(healthKitController.stepCountToday), color: .move, goal: dailyStepsGoal)
                    
                    StatRow(headerImage: stepsSystemImage, headerTitle: "Steps past 7 days", date: healthKitController.latestSteps, stat: Double(healthKitController.stepCountWeek), color: .move, goal: dailyStepsGoal * 7, destination: {
                        WeekStepsDetailView()
                    })

                    StatRow(headerImage: distanceSystemImage, headerTitle: "Distance today", date: healthKitController.latestWalkRunDistance, stat: healthKitController.walkRunDistanceToday, color: .move, units: "Miles")
                } header: {
                    Text("Activity")
                } footer: {
                    if bestStepsDay.steps > 0 {
                        HStack(spacing: 0) {
                            Text("Your best day was ")
                            Text(bestStepsDay.day, format: .dateTime.weekday().month().day())
                            Text(" with \(bestStepsDay.steps, format: .number) steps.")
                        }
                    }
                }
            }
            .navigationTitle(moveTitle)
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
    
    func refresh() {
        healthKitController.getStepCountToday()
        healthKitController.getStepCountWeek()
        
        healthKitController.getWalkRunDistanceToday()
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.stepCountToday = 2000
    healthKitController.stepCountWeek = 12000
    healthKitController.walkRunDistanceToday = 5.1
    
    let today: Date = .now
    for i in 0...6 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.stepCountWeekByDay[date] = Int.random(in: 0...15000)
        }
    }
    
    return MoveView()
        .environment(healthKitController)
}
