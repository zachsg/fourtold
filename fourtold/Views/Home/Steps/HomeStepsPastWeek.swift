//
//  HomeStepsPastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/28/23.
//

import SwiftUI

struct HomeStepsPastWeek: View {
    @Environment(HKController.self) private var hkController
    
    @Binding var stepsWeekPercent: Double
    
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    var isDone: Bool {
        stepsWeekPercent = (Double(hkController.stepCountWeek) / Double(dailyStepsGoal * 7) * 100).rounded()
        return stepsWeekPercent >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Past 7 days", headerImage: stepsSystemImage, date: hkController.latestSteps, color: .move, progress: stepsWeekPercent) {
            Text(hkController.stepCountWeek, format: .number)
                .font(.title)
                .fontWeight( isDone ? .bold : .semibold)
                .foregroundStyle(isDone ? .move : .primary)
            
            HStack(spacing: 0) {
                Text("\(percentComplete(action: hkController.stepCountWeek, goal: dailyStepsGoal, forWeek: true))")
                    .foregroundStyle(isDone ? .move : .primary)
                    .fontWeight(.heavy)
                Text(" of \(goalAbbreviated(forWeek: true))k goal")
                    .foregroundStyle(.secondary)
                    .fontWeight(.bold)
            }
            .font(.caption)
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
    let hkController = HKController()
    hkController.stepCountWeek = 75000
    
    return HomeStepsPastWeek(stepsWeekPercent: .constant(80))
        .environment(hkController)
}

