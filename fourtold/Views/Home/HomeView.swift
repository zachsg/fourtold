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
    
    @State private var tagSheetIsShowing = false
    
    @State private var stepsTodayPercent = 0.0
    @State private var stepsWeekPercent = 0.0
    @State private var zone2TodayPercent = 0.0
    @State private var zone2WeekPercent = 0.0
    @State private var mindfulTodayPercent = 0.0
    @State private var mindfulWeekPercent = 0.0
    @State private var sunTodayPercent = 0.0
    @State private var sunWeekPercent = 0.0
    
    var weekProgress: (total: Double, steps: Double, zone2: Double, rest: Double) {
        let steps = stepsWeekPercent / 100
        let zone2 = zone2WeekPercent / 100
        let rest = if hasSunlight {
            (((mindfulWeekPercent / 100 + sunWeekPercent / 100) / 2) * 100).rounded() / 100
        } else {
            sunWeekPercent / 100
        }
        
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
                    VStack {
                        Text("Past 7 days".uppercased())
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text(weekProgress.total, format: .percent)
                                    .font(.largeTitle.bold())
                                Text("Overall")
                                    .font(.caption)
                            }
                            .padding()
                            
                            Rectangle()
                                .frame(width: 2)
                                .background(.secondary)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Steps:")
                                    Text(weekProgress.steps, format: .percent)
                                        .fontWeight(.bold)
                                }
                                .foregroundStyle(.move)
                                
                                HStack {
                                    Text("Zone2:")
                                    Text(weekProgress.zone2, format: .percent)
                                        .fontWeight(.bold)
                                }
                                .foregroundStyle(.sweat)
                                
                                HStack {
                                    Text(" Rest:")
                                    Text(weekProgress.rest, format: .percent)
                                        .fontWeight(.bold)
                                }
                                .foregroundStyle(.rest)
                            }
                            
                            Spacer()
                        }
                        .fontDesign(.monospaced)
                    }
                    .padding(48)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 16))
                            .foregroundStyle(.move.opacity(0.3))
                            .overlay {
                                RoundedRectangle(cornerRadius: 1)
                                    .stroke(style: StrokeStyle(lineWidth: 16))
                                    .foregroundStyle(.sweat.opacity(0.3))
                                    .padding(16)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(style: StrokeStyle(lineWidth: 16))
                                            .padding(32)
                                            .foregroundStyle(.rest.opacity(0.3))
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 1)
                                            .trim(from: 0, to: weekProgress.rest)
                                            .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .butt, lineJoin: .round))
                                            .rotationEffect(.degrees(180))
                                            .padding(32)
                                            .foregroundStyle(.rest)
                                    }
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 1)
                                    .trim(from: 0, to: weekProgress.zone2)
                                    .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .butt, lineJoin: .round))
                                    .rotationEffect(.degrees(180))
                                    .foregroundStyle(.sweat)
                                    .padding(16)
                            }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .trim(from: 0, to: weekProgress.steps)
                            .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .butt, lineJoin: .round))
                            .rotationEffect(.degrees(180))
                            .foregroundStyle(.move)
                    }
                }
                .padding()
                
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
                
                VStack {
                    TagsTodayView()
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
            }
            .refreshable {
                refresh(hard: true)
            }
            .navigationTitle(homeTitle)
            .toolbar {
                ToolbarItem {
                    Button(tagTitle, systemImage: tagSystemImage) {
                        tagSheetIsShowing.toggle()
                    }
                }
            }
            .sheet(isPresented: $tagSheetIsShowing) {
                TagSheet(showingSheet: $tagSheetIsShowing, color: .accent)
                    .interactiveDismissDisabled()
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
        }
        
        healthKitController.getStepCountToday(refresh: hard)
        healthKitController.getStepCountWeek(refresh: hard)
        
        healthKitController.getMindfulMinutesToday(refresh: hard)
        healthKitController.getMindfulMinutesWeek(refresh: hard)
        
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
