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
    
    // VO2 max
    @AppStorage(hasVO2Key) var hasVO2: Bool = true
    
    var vO2Today: Bool {
        Calendar.current.isDateInToday(healthKitController.latestCardioFitness)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ZStack(alignment: .leading) {
                        moveColor
                        
                        NavigationLink {
                            MoveView(healthKitController: healthKitController)
                        } label: {
                            Label(moveTitle, systemImage: moveSystemImage)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    .listRowInsets(EdgeInsets())
                    
                    // TODO: Minutes Upper Body strength training this week
                    
                    // TODO: Minutes Lower Body strength training this week
                    
                    // TODO: Minutes Core strength training this week
                    
                    if hasDailyStepsGoal {
                        HomeStepsToday(healthKitController: healthKitController)
                    }
                    
                    if hasWalkRunDistance {
                        HomeWalkRunDistanceToday(healthKitController: healthKitController)
                    }
                } footer: {
                    VStack(alignment: .leading) {
                        if healthKitController.walkRunDistanceToday > 0 {
                            Text("You're taking \(stepsPerMile()) steps per mile today.")
                        }
                    }
                }
                
                Section {
                    ZStack(alignment: .leading) {
                        sweatColor
                        
                        NavigationLink {
                            
                        } label: {
                            Label(sweatTitle, systemImage: sweatSystemImage)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    .listRowInsets(EdgeInsets())
                    
                    // TODO: Zone 2 minutes today
                    
                    // TODO: Zone 2 minutes this week
                    
                    // TODO: VO2Max / Cario Fitness
                    
                    if hasVO2 && vO2Today {
                        HomeVO2Today(healthKitController: healthKitController)
                    }
                    
                    // TODO: Cardio Recovery
                }
                
                Section {
                    ZStack(alignment: .leading) {
                        buildColor
                        
                        NavigationLink {
                            
                        } label: {
                            Label(buildTitle, systemImage: buildSystemImage)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    .listRowInsets(EdgeInsets())
                }
                
                Section {
                    ZStack(alignment: .leading) {
                        restColor
                        
                        NavigationLink {
                            RestView(healthKitController: healthKitController)
                        } label: {
                            Label(restTitle, systemImage: restSystemImage)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    .listRowInsets(EdgeInsets())
                    
                    HomeMindfulMinutesToday(healthKitController: healthKitController)
                    
                    // TODO: Mood
                    
                    // TODO: Journal?
                    
                    // TODO: Time in daylight (i.e. Sun exposure)
                    
                    // TODO: Grounding / Earthing
                    
                    // TODO: Stand hours?
                }
            }
            .navigationTitle(homeTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: settingsSystemImage)
//                    Label(settingsTitle, image: settingsSystemImage)
//                        .labelStyle(.iconOnly)
                }
            }
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
        if hasVO2 {
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
