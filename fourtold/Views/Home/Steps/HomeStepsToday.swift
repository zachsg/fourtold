//
//  HomeStepsToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/28/23.
//

import SwiftUI

struct HomeStepsToday: View {
    @Environment(HKController.self) private var hkController
    
    @Binding var stepsTodayPercent: Double
    
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    var isDone: Bool {
        stepsTodayPercent = (Double(hkController.stepCountToday) / Double(dailyStepsGoal) * 100).rounded()
        return stepsTodayPercent >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Today", headerImage: stepsSystemImage, date: hkController.latestSteps, color: .move, progress: stepsTodayPercent) {
            Text(hkController.stepCountToday, format: .number)
                .font(.title)
                .fontWeight( isDone ? .bold : .semibold)
                .foregroundStyle(isDone ? .move : .primary)
            
            HStack(spacing: 0) {
                Text("\(percentComplete(action: hkController.stepCountToday, goal: dailyStepsGoal))")
                    .foregroundStyle(isDone ? .move : .primary)
                    .fontWeight(.heavy)
                Text(" of \(goalAbbreviated())k")
                    .foregroundStyle(.move.opacity(0.7))
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
    hkController.stepCountToday = 8000
    
    return HomeStepsToday(stepsTodayPercent: .constant(80))
        .environment(hkController)
}
