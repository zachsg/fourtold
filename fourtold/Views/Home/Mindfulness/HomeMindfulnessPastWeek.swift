//
//  HomeMindfulnessPastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/30/23.
//

import SwiftUI

struct HomeMindfulnessPastWeek: View {
    @Bindable var healthKitController: HealthKitController
    @Binding var mindfulWeekPercent: Double
    @AppStorage(dailyMindfulnessGoalKey) var dailyMindfulnessGoal: Int = dailyMindfulnessGoalDefault
    
    var isDone: Bool {
        mindfulWeekPercent = (Double(healthKitController.mindfulMinutesWeek) / Double((dailyMindfulnessGoal * 7) / 60) * 100).rounded()
        return mindfulWeekPercent >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Mindful 7 days", headerImage: restSystemImage, date: healthKitController.latestMindfulMinutes, color: .rest, progress: mindfulWeekPercent) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(healthKitController.mindfulMinutesWeek)")
                    .font(.title)
                    .fontWeight( isDone ? .bold : .semibold)
                    .foregroundStyle(isDone ? .rest : .primary)
                
                Text("Minutes")
                    .foregroundStyle(.secondary)
                    .font(.footnote.bold())
            }
            
            Text("\(percentComplete(action: healthKitController.mindfulMinutesWeek, goal: dailyMindfulnessGoal, forWeek: true)) of \(goalAbbreviated(forWeek: true))")
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
    HomeMindfulnessPastWeek(healthKitController: HealthKitController(), mindfulWeekPercent: .constant(80))
}
