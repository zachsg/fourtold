//
//  MoveView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftUI

struct MoveView: View {
    @Bindable var healthKitController: HealthKitController
    
    // Steps
    @AppStorage(hasDailyStepsGoalKey) var hasDailyStepsGoal: Bool = true
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = 10000
    
    // Walk/run distance
    @AppStorage(hasWalkRunDistanceKey) var hasWalkRunDistance: Bool = true
    
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
                    HomeStepsToday(healthKitController: healthKitController)
                    
                    MoveStepsPastWeek(healthKitController: healthKitController)
                    
                    if hasWalkRunDistance {
                        HomeWalkRunDistanceToday(healthKitController: healthKitController)
                    }
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
            .refreshable {
                refresh()
            }
        }
    }
    
    func refresh() {
        if hasDailyStepsGoal {
            healthKitController.getStepCountToday(refresh: true)
            healthKitController.getStepCountWeek(refresh: true)
            healthKitController.getStepCountWeekByDay(refresh: true)
        }
        
        if hasWalkRunDistance {
            healthKitController.getWalkRunDistanceToday(refresh: true)
        }
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
    
    return MoveView(healthKitController: healthKitController)
}
