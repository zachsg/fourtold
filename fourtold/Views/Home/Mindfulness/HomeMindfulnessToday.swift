//
//  HomeMindfulMinutesToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import SwiftUI

struct HomeMindfulnessToday: View {
    @Bindable var healthKitController: HealthKitController
    @Binding var mindfulTodayPercent: Double
    @AppStorage(dailyMindfulnessGoalKey) var dailyMindfulnessGoal: Int = dailyMindfulnessGoalDefault
    
    var isDone: Bool {
        mindfulTodayPercent = (Double(healthKitController.mindfulMinutesToday) / Double(dailyMindfulnessGoal / 60) * 100).rounded()
        return mindfulTodayPercent >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Mindful today", headerImage: restSystemImage, date: healthKitController.latestMindfulMinutes, color: .rest, isDone: isDone) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(healthKitController.mindfulMinutesToday)")
                    .font(.title)
                    .fontWeight( isDone ? .bold : .semibold)
                    .foregroundStyle(isDone ? .rest : .primary)
                
                Text("Minutes")
                    .foregroundStyle(.secondary)
                    .font(.footnote.bold())
            }
            
            Text("\(percentComplete(action: healthKitController.mindfulMinutesToday, goal: dailyMindfulnessGoal)) of \(goalAbbreviated())")
                .foregroundStyle(.secondary)
                .font(.caption)
                .fontWeight(.heavy)
        }
    }
    
    func percentComplete(action: Int, goal: Int, forWeek: Bool = false) -> String {
        let percent = (Double(action) / Double(forWeek ? (goal * 7) / 60 : goal / 60) * 100).rounded()
        
        return String(format: "%.0f%%", percent)
    }
    
    func goalAbbreviated(forWeek: Bool = false) -> String {
        let goal = Double(forWeek ? dailyMindfulnessGoal * 7 : dailyMindfulnessGoal) / 60
        
        return (goal * 60).secondsAsTimeRoundedToMinutes(units: .short)
    }
}

#Preview {
    HomeMindfulnessToday(healthKitController: HealthKitController(), mindfulTodayPercent: .constant(80))
}
