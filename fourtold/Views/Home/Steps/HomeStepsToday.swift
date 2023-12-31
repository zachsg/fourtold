//
//  HomeStepsToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/28/23.
//

import SwiftUI

struct HomeStepsToday: View {
    @Bindable var healthKitController: HealthKitController
    @Binding var stepsTodayPercent: Double
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    var isDone: Bool {
        stepsTodayPercent = (Double(healthKitController.stepCountToday) / Double(dailyStepsGoal) * 100).rounded()
        return stepsTodayPercent >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Steps today", headerImage: stepsSystemImage, date: healthKitController.latestSteps, color: .move, isDone: isDone) {
            Text(healthKitController.stepCountToday, format: .number)
                .font(.title)
                .fontWeight( isDone ? .bold : .semibold)
                .foregroundStyle(isDone ? .move : .primary)
            
            Text("\(percentComplete(action: healthKitController.stepCountToday, goal: dailyStepsGoal)) of \(goalAbbreviated())k")
                .foregroundStyle(.secondary)
                .font(.caption)
                .fontWeight(.heavy)
        }
    }
    
    func percentComplete(action: Int, goal: Int, forWeek: Bool = false) -> String {
        let percent = (Double(action) / Double(forWeek ? goal * 7 : goal) * 100).rounded()
        
        return String(format: "%.0f%%", percent)
    }
    
    func goalAbbreviated(forWeek: Bool = false) -> String {
        let goal = Double(forWeek ? dailyStepsGoal * 7 : dailyStepsGoal) / 1000
        
        return goal.rounded() == goal ? String(format: "%.0f%", goal) : String(format: "%.1f%", goal)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.stepCountToday = 9500
    
    return HomeStepsToday(healthKitController: healthKitController, stepsTodayPercent: .constant(80))
}
