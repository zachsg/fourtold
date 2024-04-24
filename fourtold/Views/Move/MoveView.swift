//
//  MoveView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftUI

struct MoveView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(HKController.self) private var hkController
    
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    var bestStepsDay: (day: Date, steps: Int) {
        var bestDay: Date = .now
        var bestSteps = 0
        
        for (day, minutes) in hkController.stepCountWeekByDay {
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
                    StatRow(headerImage: stepsSystemImage, headerTitle: "Steps today", date: hkController.latestSteps, stat: Double(hkController.stepCountToday), color: .move, goal: dailyStepsGoal)
                    
                    StatRow(headerImage: stepsSystemImage, headerTitle: "Steps past 7 days", date: hkController.latestSteps, stat: Double(hkController.stepCountWeek), color: .move, goal: dailyStepsGoal * 7, destination: {
                        WeekStepsDetailView()
                    })

                    StatRow(headerImage: distanceSystemImage, headerTitle: "Distance today", date: hkController.latestWalkRunDistance, stat: hkController.walkRunDistanceToday, color: .move, units: "Miles")
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
        hkController.getStepCountToday()
        hkController.getStepCountWeek()
        
        hkController.getWalkRunDistanceToday()
    }
}

#Preview {
    let hkController = HKController()
    hkController.stepCountToday = 2000
    hkController.stepCountWeek = 12000
    hkController.walkRunDistanceToday = 5.1
    
    let today: Date = .now
    for i in 0...6 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            hkController.stepCountWeekByDay[date] = Int.random(in: 0...15000)
        }
    }
    
    return MoveView()
        .environment(hkController)
}
