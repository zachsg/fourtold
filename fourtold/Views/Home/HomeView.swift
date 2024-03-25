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

    @State private var tagSheetIsShowing = false
    
    @State private var stepsTodayPercent = 0.0
    @State private var stepsWeekPercent = 0.0
    @State private var zone2TodayPercent = 0.0
    @State private var zone2WeekPercent = 0.0
    @State private var mindfulTodayPercent = 0.0
    @State private var mindfulWeekPercent = 0.0

    @State private var showToday = false
    @State private var animationAmount = 0.0
    
    var todayProgress: (total: Double, steps: Double, zone2: Double, rest: Double) {
        let steps = stepsTodayPercent / 100
        let zone2 = zone2TodayPercent / 100
        let rest = ((mindfulTodayPercent / 100) * 100).rounded() / 100

        let totalSteps = steps >= 1 ?  1 : steps
        let totalZone2 = zone2 >= 1 ? 1 : zone2
        let totalRest = rest >= 1 ? 1 : rest
        
        let total = ((totalSteps + totalZone2 + totalRest) / 3 * 100).rounded() / 100
        
        return (total, steps, zone2, rest)
    }
    
    var weekProgress: (total: Double, steps: Double, zone2: Double, rest: Double) {
        let steps = stepsWeekPercent / 100
        let zone2 = zone2WeekPercent / 100
        let rest = ((mindfulWeekPercent / 100) * 100).rounded() / 100

        let totalSteps = steps >= 1 ?  1 : steps
        let totalZone2 = zone2 >= 1 ? 1 : zone2
        let totalRest = rest >= 1 ? 1 : rest
        
        let total = ((totalSteps + totalZone2 + totalRest) / 3 * 100).rounded() / 100
        
        return (total, steps, zone2, rest)
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if showToday {
                        HomeOverall(title: "Today", progress: todayProgress)
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                    } else {
                        HomeOverall(title: "Past 7 days", progress: weekProgress)
                    }
                }
                .frame(height: 320)
                .padding()
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {
                    withAnimation {
                        animationAmount = animationAmount == 0 ? 180 : 0
                        showToday.toggle()
                    }
                }
                .padding(.bottom, 2)

                /// Move
                VStack {
                    HomeStepsCards(healthKitController: healthKitController, stepsTodayPercent: $stepsTodayPercent, stepsWeekPercent: $stepsWeekPercent)
                }
                .padding(2)
                .background(.thickMaterial)
                .background(.move.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)

                /// Sweat
                VStack {
                    HomeZone2Cards(healthKitController: healthKitController, zone2TodayPercent: $zone2TodayPercent, zone2WeekPercent: $zone2WeekPercent)
                }
                .padding(2)
                .background(.thickMaterial)
                .background(.sweat.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 8)
                .padding(.bottom, 2)

                /// Rest
                VStack {
                    HomeMindfulnessCards(healthKitController: healthKitController, mindfulTodayPercent: $mindfulTodayPercent, mindfulWeekPercent: $mindfulWeekPercent)
                }
                .padding(2)
                .background(.thickMaterial)
                .background(.rest.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 8)
            }
            .refreshable {
                refresh()
            }
            .navigationTitle(summaryTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label(settingsTitle, systemImage: settingsSystemImage)
                    }
                }
            }
            .sheet(isPresented: $tagSheetIsShowing) {
                TagSheet(showingSheet: $tagSheetIsShowing, color: .accent)
                    .interactiveDismissDisabled()
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    refresh()
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
    
    func refresh() {
        healthKitController.getZone2Today()
        healthKitController.getZone2Week()

        healthKitController.getStepCountToday()
        healthKitController.getStepCountWeek()
        
        healthKitController.getMindfulMinutesToday()
        healthKitController.getMindfulMinutesWeek()
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
    healthKitController.stepCountToday = 10000
    healthKitController.stepCountWeek = 65000
    healthKitController.walkRunDistanceToday = 5.1
    healthKitController.cardioFitnessMostRecent = 44.1
    healthKitController.mindfulMinutesToday = 20
    healthKitController.mindfulMinutesWeek = 60
    healthKitController.zone2Today = 15
    healthKitController.zone2Week = 75
    
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
