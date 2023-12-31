//
//  HomeStepsPastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/28/23.
//

import SwiftUI

struct HomeStepsPastWeek: View {
    @Bindable var healthKitController: HealthKitController
    @Binding var stepsWeekPercent: Double
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    var isDone: Bool {
        stepsWeekPercent = (Double(healthKitController.stepCountWeek) / Double(dailyStepsGoal * 7) * 100).rounded()
        return stepsWeekPercent >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Past 7 days", headerImage: stepsSystemImage, date: healthKitController.latestSteps, color: .move, progress: stepsWeekPercent) {
            Text(healthKitController.stepCountWeek, format: .number)
                .font(.title)
                .fontWeight( isDone ? .bold : .semibold)
                .foregroundStyle(isDone ? .move : .primary)
            
            Text("\(percentComplete(action: healthKitController.stepCountWeek, goal: dailyStepsGoal, forWeek: true)) of \(goalAbbreviated(forWeek: true))k goal")
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
    healthKitController.stepCountWeek = 75000
    
    return HomeStepsPastWeek(healthKitController: healthKitController, stepsWeekPercent: .constant(80))
}

