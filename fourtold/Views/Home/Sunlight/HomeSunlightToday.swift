//
//  HomeTimeInDaylightToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/28/23.
//

import SwiftUI

struct HomeSunlightToday: View {
    @Bindable var healthKitController: HealthKitController
    @Binding var sunTodayPercent: Double
    @AppStorage(dailySunlightGoalKey) var dailySunlightGoal: Int = dailySunlightGoalDefault
    
    var isDone: Bool {
        sunTodayPercent = (Double(healthKitController.timeInDaylightToday) / Double(dailySunlightGoal / 60) * 100).rounded()
        return sunTodayPercent >= 100
    }
    
    var timeAndUnits: (time: Double, units: String) {
        let time = healthKitController.timeInDaylightToday
        
        if time > 60 {
            let rounded = Double(round(100 * Double(time) / 60) / 100)
            return (rounded, "Hours")
        } else {
            return (Double(time), "Minutes")
        }
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Today", headerImage: sunlightSystemImage, date: healthKitController.latestTimeInDaylight, color: .rest, progress: sunTodayPercent) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Group {
                    if timeAndUnits.units == "Minutes" {
                        Text(Int(timeAndUnits.time), format: .number)
                    } else {
                        Text(timeAndUnits.time, format: .number)
                    }
                }
                .font(.title)
                .fontWeight( isDone ? .bold : .semibold)
                .foregroundStyle(isDone ? .rest : .primary)
                
                Text(timeAndUnits.units)
                    .foregroundStyle(.secondary)
                    .font(.footnote.bold())
            }
            
            HStack(spacing: 0) {
                Text("\(percentComplete(action: healthKitController.timeInDaylightToday, goal: dailySunlightGoal))")
                    .foregroundStyle(.rest)
                    .fontWeight(.heavy)
                Text(" of \(goalAbbreviated())")
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
        let goal = Double(forWeek ? dailySunlightGoal * 7 : dailySunlightGoal) / 60
        
        return (goal * 60).secondsAsTimeRoundedToMinutes(units: .short)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.latestTimeInDaylight = .now
    healthKitController.timeInDaylightToday = 60
    
    return HomeSunlightToday(healthKitController: healthKitController, sunTodayPercent: .constant(80))
}
