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
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    // Zone 2
    @AppStorage(hasZone2Key) var hasZone2: Bool = hasZone2Default
    
    // Time in Daylight
    @AppStorage(hasSunlightKey) var hasSunlight: Bool = hasSunlightDefault
    
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
                        
                        if hasZone2 {
                            HomeZone2Today(healthKitController: healthKitController)
                        }
                        
                        HomeMindfulnessToday(healthKitController: healthKitController)
                        
                        if hasSunlight {
                            HomeSunlightToday(healthKitController: healthKitController)
                        }
                    }
                    
                    VStack {
                        HomeStepsPastWeek(healthKitController: healthKitController)
                        
                        if hasZone2 {
                            HomeZone2PastWeek(healthKitController: healthKitController)
                        }
                        
                        HomeMindfulnessPastWeek(healthKitController: healthKitController)
                        
                        if hasSunlight {
                            HomeSunlightPastWeek(healthKitController: healthKitController)
                        }
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
        if hasZone2 {
            healthKitController.getZone2Today(refresh: hard)
            healthKitController.getZone2Week(refresh: hard)
        }
        
        healthKitController.getStepCountToday(refresh: hard)
        healthKitController.getStepCountWeek(refresh: hard)
//            healthKitController.getStepCountWeekByDay(refresh: hard)
                
        healthKitController.getMindfulMinutesToday(refresh: hard)
        healthKitController.getMindfulMinutesRecent(refresh: hard)
//        healthKitController.getMindfulMinutesWeekByDay(refresh: hard)
        
        if hasSunlight {
            healthKitController.getTimeInDaylightToday(refresh: hard)
            healthKitController.getTimeInDaylightWeek(refresh: hard)
        }
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
