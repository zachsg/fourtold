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
                    if healthKitController.walkRunDistanceToday > 0 {
                        Text("You're taking \(stepsPerMile()) steps per mile today.")
                    }
                }
                
                Section(mindTitle) {
                    HomeMindfulMinutesToday(healthKitController: healthKitController)
                    
                    HomeMindfulMinutesPastWeek(healthKitController: healthKitController)
                    
                    // TODO: Time in daylight (i.e. Sun exposure)
                    
                    // TODO: Grounding / Earthing
                }
                
                Section(lifeTitle) {
                    // TODO: Mood
                
                    // TODO: Journal?
                }
            }
            .navigationTitle(homeTitle)
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
        if hasCardio {
            healthKitController.getCardioFitnessRecent()
        }
        
        if hasDailyStepsGoal {
            healthKitController.getStepCountToday()
            healthKitController.getStepCountWeek()
        }
        
        if hasWalkRunDistance {
            healthKitController.getWalkRunDistanceToday()
        }
        
        healthKitController.getMindfulMinutesToday()
        healthKitController.getMindfulMinutesRecent()
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
    
    return HomeView(healthKitController: healthKitController)
}
