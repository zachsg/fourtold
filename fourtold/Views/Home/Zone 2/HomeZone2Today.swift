//
//  HomeZone2Today.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/30/23.
//

import SwiftUI

struct HomeZone2Today: View {
    @Bindable var healthKitController: HealthKitController
    @Binding var zone2TodayPercent: Double
    @AppStorage(dailyZone2GoalKey) var dailyZone2Goal: Int = dailyZone2GoalDefault
    
    var isDone: Bool {
        zone2TodayPercent = (Double(healthKitController.zone2Today) / Double(dailyZone2Goal / 60) * 100).rounded()
        return zone2TodayPercent >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Today", headerImage: vO2SystemImage, date: healthKitController.latestZone2, color: .move, progress: zone2TodayPercent) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(healthKitController.zone2Today)")
                    .font(.title)
                    .fontWeight( isDone ? .bold : .semibold)
                    .foregroundStyle(isDone ? .move : .primary)
                
                Text("Minutes")
                    .foregroundStyle(.move.opacity(0.5))
                    .font(.footnote.bold())
            }
            
            HStack(spacing: 0) {
                Text("\(percentComplete(action: healthKitController.zone2Today, goal: dailyZone2Goal))")
                    .foregroundStyle(isDone ? .move : .primary)
                    .fontWeight(.heavy)
                Text(" of \(goalAbbreviated())")
                    .foregroundStyle(.move.opacity(0.5))
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
        let goal = Double(forWeek ? dailyZone2Goal * 7 : dailyZone2Goal) / 60
        
        return (goal * 60).secondsAsTimeRoundedToMinutes(units: .short)
    }
}

#Preview {
    HomeZone2Today(healthKitController: HealthKitController(), zone2TodayPercent: .constant(80))
}
