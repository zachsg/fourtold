//
//  HomeView.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 4/26/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(HKController.self) private var hkController
    
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault

    @State private var stepsTodayPercent = 0.0
    @State private var stepsWeekPercent = 0.0
    @State private var zone2TodayPercent = 0.0
    @State private var zone2WeekPercent = 0.0
    @State private var mindfulTodayPercent = 0.0
    @State private var mindfulWeekPercent = 0.0

    @State private var tagSheetIsShowing = false
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
    
    var body: some View {
        VStack {
            if showToday {
                HomeOverall(title: "Today", progress: todayProgress)
                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
            } else {
                HomeOverall(title: "Past 7 days", progress: weekProgress)
            }
        }
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation {
                animationAmount = animationAmount == 0 ? 180 : 0
                showToday.toggle()
            }
        }
    }
}

#Preview {
    let hkController = HKController()
    hkController.stepCountToday = 10000
    hkController.stepCountWeek = 65000
    hkController.mindfulMinutesToday = 20
    hkController.mindfulMinutesWeek = 60
    hkController.zone2Today = 15
    hkController.zone2Week = 75
    
    return HomeView()
        .environment(hkController)
}
