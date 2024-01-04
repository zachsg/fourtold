//
//  MoveView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/6/23.
//

import SwiftUI

struct MoveView: View {
    @Environment(\.scenePhase) var scenePhase
    @Bindable var healthKitController: HealthKitController
    
    // Steps
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    @State private var tagSheetIsShowing = false
    
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
                    MoveStepsToday(healthKitController: healthKitController)
                    
                    MoveStepsPastWeek(healthKitController: healthKitController)
                    
                    MoveWalkRunDistanceToday(healthKitController: healthKitController)
                } footer: {
                    if bestStepsDay.steps > 0 {
                        HStack(spacing: 0) {
                            Text("Your best day was ")
                            Text(bestStepsDay.day, format: .dateTime.weekday().month().day())
                            Text(" with \(bestStepsDay.steps, format: .number) steps.")
                        }
                    }
                }
                
                TagsTodayView()
                
                TagsOldView(color: .move)
            }
            .navigationTitle(moveTitle)
            .toolbar {
                ToolbarItem {
                    Button(tagTitle, systemImage: tagSystemImage) {
                        tagSheetIsShowing.toggle()
                    }
                    .tint(.move)
                }
            }
            .sheet(isPresented: $tagSheetIsShowing) {
                TagSheet(showingSheet: $tagSheetIsShowing, color: .move)
                    .interactiveDismissDisabled()
            }
            .onAppear(perform: {
                if healthKitController.stepCountWeek == 0 {
                    refresh(hard: true)
                } else {
                    refresh()
                }
            })
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    let today = Calendar.current.isDateInToday(healthKitController.latestSteps)
                    refresh(hard: !today)
                }
            }
            .refreshable {
                refresh()
            }
        }
    }
    
    func refresh(hard: Bool = false) {
        healthKitController.getStepCountToday(refresh: hard)
        healthKitController.getStepCountWeek(refresh: hard)
        
        healthKitController.getWalkRunDistanceToday(refresh: hard)
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
