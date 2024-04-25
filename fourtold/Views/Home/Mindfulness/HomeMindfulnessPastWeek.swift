//
//  HomeMindfulnessPastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/30/23.
//

import SwiftUI

struct HomeMindfulnessPastWeek: View {
    @Environment(HKController.self) private var hkController
    
    @Binding var mindfulWeekPercent: Double
    
    @AppStorage(dailyMindfulnessGoalKey) var dailyMindfulnessGoal: Int = dailyMindfulnessGoalDefault
    
    var isDone: Bool {
        mindfulWeekPercent = (Double(hkController.mindfulMinutesWeek) / Double((dailyMindfulnessGoal * 7) / 60) * 100).rounded()
        return mindfulWeekPercent >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Past 7 days", headerImage: restSystemImage, date: hkController.latestMindfulMinutes, color: .rest, progress: mindfulWeekPercent) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(hkController.mindfulMinutesWeek)")
                    .font(.title)
                    .fontWeight( isDone ? .bold : .semibold)
                    .foregroundStyle(isDone ? .rest : .primary)
                
                Text("Minutes")
                    .foregroundStyle(.secondary)
                    .font(.footnote.bold())
            }
            
            HStack(spacing: 0) {
                Text("\(percentComplete(action: hkController.mindfulMinutesWeek, goal: dailyMindfulnessGoal, forWeek: true))")
                    .foregroundStyle(isDone ? .rest : .primary)
                    .fontWeight(.heavy)
                Text(" of \(goalAbbreviated(forWeek: true))")
                    .foregroundStyle(.secondary)
                    .fontWeight(.bold)
            }
            .font(.caption)
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
    let hkController = HKController()
    
    return HomeMindfulnessPastWeek(mindfulWeekPercent: .constant(80))
        .environment(hkController)
}
