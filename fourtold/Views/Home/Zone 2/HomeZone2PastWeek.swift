//
//  HomeZone2PastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/30/23.
//

import SwiftUI

struct HomeZone2PastWeek: View {
    @Environment(HKController.self) private var hkController
    
    @Binding var zone2WeekPercent: Double
    
    @AppStorage(dailyZone2GoalKey) var dailyZone2Goal: Int = dailyZone2GoalDefault
    
    var isDone: Bool {
        zone2WeekPercent = (Double(hkController.zone2Week) / Double((dailyZone2Goal * 7) / 60) * 100).rounded()
        return zone2WeekPercent >= 100
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Past 7 days", headerImage: vO2SystemImage, date: hkController.latestZone2, color: .sweat, progress: zone2WeekPercent) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(hkController.zone2Week)")
                    .font(.title)
                    .fontWeight( isDone ? .bold : .semibold)
                    .foregroundStyle(isDone ? .sweat : .primary)
                
                Text("Minutes")
                    .foregroundStyle(.secondary)
                    .font(.footnote.bold())
            }
            
            HStack(spacing: 0) {
                Text("\(percentComplete(action: hkController.zone2Week, goal: dailyZone2Goal, forWeek: true))")
                    .foregroundStyle(isDone ? .sweat : .primary)
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
        let goal = Double(forWeek ? dailyZone2Goal * 7 : dailyZone2Goal) / 60
        
        return (goal * 60).secondsAsTimeRoundedToMinutes(units: .short)
    }
}

#Preview {
    let hkController = HKController()
    
    return HomeZone2PastWeek(zone2WeekPercent: .constant(80))
        .environment(hkController)
}

