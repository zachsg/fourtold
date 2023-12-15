//
//  HomeView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @Bindable var healthKitController: HealthKitController
    
    // Steps
    @AppStorage(hasDailyStepsGoalKey) var hasDailyStepsGoal: Bool = true
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = 10000
    
    // Walk/run distance
    @AppStorage(hasWalkRunDistanceKey) var hasWalkRunDistance: Bool = true
    
    // Cardio
    @AppStorage(hasCardioKey) var hasCardio: Bool = true
    
    var cardioToday: Bool {
        Calendar.current.isDateInToday(healthKitController.latestCardioFitness)
    }
    
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
    
    var bestMindfulDay: (day: Date, minutes: Int) {
        var bestDay: Date = .now
        var bestMinutes = 0
        
        for (day, minutes) in healthKitController.mindfulMinutesWeekByDay {
            if minutes > bestMinutes {
                bestDay = day
                bestMinutes = minutes
            }
        }
        
        return (bestDay, bestMinutes)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if hasCardio {
                        // TODO: Zone 2 minutes today
                        
                        // TODO: Zone 2 minutes this week
                        
                        // TODO: VO2Max / Cario Fitness
                        
                        if cardioToday {
                            HomeCardioFitnessToday(healthKitController: healthKitController)
                        }
                        
                        // TODO: Cardio Recovery
                    }
                    
                    // TODO: Minutes Upper Body strength training this week
                    
                    // TODO: Minutes Lower Body strength training this week
                    
                    // TODO: Minutes Core strength training this week
                    
                    if hasDailyStepsGoal {
                        HomeStepsToday(healthKitController: healthKitController)
                        
                        HomeStepsPastWeek(healthKitController: healthKitController)
                    }
                    
                    if hasWalkRunDistance {
                        HomeWalkRunDistanceToday(healthKitController: healthKitController)
                    }
                } header: {
                    Text(bodyTitle)
                } footer: {
                    VStack(alignment: .leading) {
                        if healthKitController.walkRunDistanceToday > 0 {
                            Text("You're taking \(stepsPerMile()) steps per mile today.")
                        }
                        
                        if bestStepsDay.steps > 0 {
                            HStack(spacing: 0) {
                                Text("Your best day was ")
                                Text(bestStepsDay.day, format: .dateTime.weekday().month().day())
                                Text(" with \(bestStepsDay.steps, format: .number) steps.")
                            }
                        }
                    }
                }
                
                Section {
                    HomeMindfulMinutesToday(healthKitController: healthKitController)
                    
                    HomeMindfulMinutesPastWeek(healthKitController: healthKitController)
                    
                    // TODO: Mood
                    
                    // TODO: Journal?
                    
                    // TODO: Time in daylight (i.e. Sun exposure)
                    
                    // TODO: Grounding / Earthing
                    
                    // TODO: Stand hours?
                } header: {
                    Text(mindTitle)
                } footer: {
                    if bestMindfulDay.minutes > 0 {
                        HStack(spacing: 0) {
                            Text("Your best day was ")
                            Text(bestMindfulDay.day, format: .dateTime.weekday().month().day())
                            Text(" with \(bestMindfulDay.minutes) minutes.")
                        }
                    }
                }
            }
            .navigationTitle(homeTitle)
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    let today = Calendar.current.isDateInToday(healthKitController.latestSteps)
                    refresh(hard: !today)
                }
            }
            .refreshable {
                refresh(hard: true)
            }
        }
    }
    
    func refresh(hard: Bool = false) {
        if hasCardio {
            healthKitController.getCardioFitnessRecent(refresh: hard)
        }
        
        if hasDailyStepsGoal {
            healthKitController.getStepCountToday(refresh: hard)
            healthKitController.getStepCountWeek(refresh: hard)
            healthKitController.getStepCountWeekByDay(refresh: hard)
        }
        
        if hasWalkRunDistance {
            healthKitController.getWalkRunDistanceToday(refresh: hard)
        }
        
        healthKitController.getMindfulMinutesToday(refresh: hard)
        healthKitController.getMindfulMinutesRecent(refresh: hard)
        healthKitController.getMindfulMinutesWeekByDay(refresh: hard)
    }
    
    func stepsPerMile() -> String {
        let stepsToday = Double(healthKitController.stepCountToday)
        let distanceToday = healthKitController.walkRunDistanceToday
        
        if distanceToday > 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedNumber = formatter.string(from: NSNumber(value: Int((stepsToday / distanceToday).rounded())))
            return formattedNumber  ?? "..."
        } else {
            return "..."
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.stepCountToday = 2000
    healthKitController.stepCountWeek = 12000
    healthKitController.walkRunDistanceToday = 5.1
    healthKitController.cardioFitnessMostRecent = 44.1
    healthKitController.mindfulMinutesToday = 20
    healthKitController.mindfulMinutesWeek = 60
    
    let today: Date = .now
    for i in 0...6 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.mindfulMinutesWeekByDay[date] = Int.random(in: 0...20)
        }
    }
    
    for i in 0...6 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.stepCountWeekByDay[date] = Int.random(in: 0...15000)
        }
    }
    
    return HomeView(healthKitController: healthKitController)
}
