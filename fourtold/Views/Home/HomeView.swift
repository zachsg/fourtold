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
    @AppStorage(hasDailyStepsGoalKey) var hasDailyStepsGoal: Bool = hasDailyStepsGoalDefault
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    // Walk/run distance
    @AppStorage(hasWalkRunDistanceKey) var hasWalkRunDistance: Bool = hasWalkRunDistanceDefault
    
    // VO2 max
    @AppStorage(hasVO2Key) var hasVO2: Bool = hasVO2Default
    
    var vO2Today: Bool {
        Calendar.current.isDateInToday(healthKitController.latestCardioFitness)
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(alignment: .top) {
                    Spacer()
                    
                    VStack {
                        HomeStepsToday(healthKitController: healthKitController)
                        
                        HomeWalkRunDistanceToday(healthKitController: healthKitController)
                        
                        HomeMindfulMinutesToday(healthKitController: healthKitController)
                    }
                    
                    VStack {
                        HomeStepsPastWeek(healthKitController: healthKitController)
                        
                        HomeVO2Today(healthKitController: healthKitController)
                    }
                    
                    Spacer()
                }
            }
            .refreshable {
                refresh(hard: true)
            }
            .navigationTitle(homeTitle)
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    let today = Calendar.current.isDateInToday(healthKitController.latestSteps)
                    refresh(hard: !today)
                }
            }
        }
    }
    
    func refresh(hard: Bool = false) {
        if hasVO2 {
            healthKitController.getCardioFitnessRecent(refresh: hard)
        }
        
        if hasDailyStepsGoal {
            healthKitController.getStepCountToday(refresh: hard)
            healthKitController.getStepCountWeek(refresh: hard)
//            healthKitController.getStepCountWeekByDay(refresh: hard)
        }
        
        if hasWalkRunDistance {
            healthKitController.getWalkRunDistanceToday(refresh: hard)
        }
        
        healthKitController.getMindfulMinutesToday(refresh: hard)
        healthKitController.getMindfulMinutesRecent(refresh: hard)
//        healthKitController.getMindfulMinutesWeekByDay(refresh: hard)
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
