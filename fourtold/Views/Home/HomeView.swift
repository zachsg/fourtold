//
//  HomeView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @Bindable var healthKitController: HealthKitController
    
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    @AppStorage(hasZone2Key) var hasZone2: Bool = hasZone2Default
    @AppStorage(hasSunlightKey) var hasSunlight: Bool = hasSunlightDefault
    
    @State private var stepsTodayPercent = 0.0
    @State private var stepsWeekPercent = 0.0
    @State private var zone2TodayPercent = 0.0
    @State private var zone2WeekPercent = 0.0
    @State private var mindfulTodayPercent = 0.0
    @State private var mindfulWeekPercent = 0.0
    @State private var sunTodayPercent = 0.0
    @State private var sunWeekPercent = 0.0
    
    var goals: (total: Double, done: Double)  {
        var total = 8.0
        var done = 0.0
        
        if !hasZone2 { total -= 1 }
        if !hasSunlight { total -= 1 }
        
        if stepsTodayPercent >= 100 { done += 1 }
        if stepsWeekPercent >= 100 { done += 1 }
        if hasZone2 && zone2TodayPercent >= 100 { done += 1 }
        if hasZone2 && zone2WeekPercent >= 100 { done += 1 }
        if mindfulTodayPercent >= 100 { done += 1 }
        if mindfulWeekPercent >= 100 { done += 1 }
        if hasSunlight && sunTodayPercent >= 100 { done += 1 }
        if hasSunlight && sunWeekPercent >= 100 { done += 1 }
        
        return (total, done)
    }
    
    var complete: Double {
        ((goals.done / goals.total) * 100).rounded() / 100
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HomeStepsCards(healthKitController: healthKitController, stepsTodayPercent: $stepsTodayPercent, stepsWeekPercent: $stepsWeekPercent)
                    
                    HomeZone2Cards(healthKitController: healthKitController, zone2TodayPercent: $zone2TodayPercent, zone2WeekPercent: $zone2WeekPercent)
                    
                }
                .padding(2)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack {
                    HomeMindfulnessCards(healthKitController: healthKitController, mindfulTodayPercent: $mindfulTodayPercent, mindfulWeekPercent: $mindfulWeekPercent)
                    
                    HomeSunlightCards(healthKitController: healthKitController, sunTodayPercent: $sunTodayPercent, sunWeekPercent: $sunWeekPercent)
                }
                .padding(4)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .refreshable {
                refresh(hard: true)
            }
            .navigationTitle(homeTitle)
            .toolbar {
                HStack(spacing: 0) {
                    Text(complete, format: .percent)
                        .fontWeight(.bold)
                        .foregroundStyle(complete < 0.30 ? .red : complete < 0.70 ? .accent : .green)
                    Text(" progress")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    let today = Calendar.current.isDateInToday(healthKitController.latestSteps)
                    refresh(hard: !today)
                }
            }
        }
    }
    
    func dateView(date: Date) -> some View {
        Group {
            if Calendar.current.isDateInYesterday(date) {
                Text("Updated yesterday")
            } else if Calendar.current.isDateInToday(date) {
                Text(date, format: .dateTime.hour().minute())
            } else if date == .distantPast {
                Text("")
            } else  {
                HStack(spacing: 0) {
                    Text("Updated ")
                    Text(date, format: .dateTime.day().month())
                }
            }
        }
        .font(.footnote.bold())
        .foregroundStyle(.secondary)
    }
    
    func refresh(hard: Bool = false) {
        if hasZone2 {
            healthKitController.getZone2Today(refresh: hard)
            healthKitController.getZone2Week(refresh: hard)
            healthKitController.getZone2WeekByDay(refresh: hard)
        }
        
        healthKitController.getStepCountToday(refresh: hard)
        healthKitController.getStepCountWeek(refresh: hard)
        healthKitController.getStepCountWeekByDay(refresh: hard)
        
        healthKitController.getMindfulMinutesToday(refresh: hard)
        healthKitController.getMindfulMinutesWeek(refresh: hard)
        //        healthKitController.getMindfulMinutesWeekByDay(refresh: hard)
        
        if hasSunlight {
            healthKitController.getTimeInDaylightToday(refresh: hard)
            healthKitController.getTimeInDaylightWeek(refresh: hard)
            healthKitController.getTimeInDaylightWeekByDay(refresh: hard)
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
    healthKitController.stepCountToday = 15000
    healthKitController.stepCountWeek = 65000
    healthKitController.walkRunDistanceToday = 5.1
    healthKitController.cardioFitnessMostRecent = 44.1
    healthKitController.mindfulMinutesToday = 20
    healthKitController.mindfulMinutesWeek = 60
    healthKitController.zone2Today = 30
    healthKitController.zone2Week = 145
    healthKitController.timeInDaylightToday = 30
    healthKitController.timeInDaylightWeek = 75
    
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
