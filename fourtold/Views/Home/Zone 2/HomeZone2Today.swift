//
//  HomeZone2Today.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/30/23.
//

import SwiftUI

struct HomeZone2Today: View {
    @Bindable var healthKitController: HealthKitController
    @AppStorage(dailyZone2GoalKey) var dailyZone2Goal: Int = dailyZone2GoalDefault
    
    var isDone: Bool {
        (Double(healthKitController.zone2Today) / Double(dailyZone2Goal / 60) * 100).rounded() >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Zone 2+ today", headerImage: vO2SystemImage, date: healthKitController.latestZone2, color: .move, isDone: isDone) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(healthKitController.zone2Today)")
                    .font(.title)
                    .fontWeight( isDone ? .bold : .semibold)
                    .foregroundStyle(isDone ? .move : .primary)
                
                Text("Minutes")
                    .foregroundStyle(.secondary)
                    .font(.footnote.bold())
            }
            
            Text("\(percentComplete(action: healthKitController.zone2Today, goal: dailyZone2Goal)) of \(goalAbbreviated())")
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
        let goal = Double(forWeek ? dailyZone2Goal * 7 : dailyZone2Goal) / 60
        
        return (goal * 60).secondsAsTimeRoundedToMinutes(units: .short)
    }
}

#Preview {
    HomeZone2Today(healthKitController: HealthKitController())
}
