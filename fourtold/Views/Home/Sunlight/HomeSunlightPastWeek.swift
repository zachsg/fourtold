//
//  HomeSunlightPastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/30/23.
//

import SwiftUI

struct HomeSunlightPastWeek: View {
    @Bindable var healthKitController: HealthKitController
    @AppStorage(dailySunlightGoalKey) var dailySunlightGoal: Int = dailySunlightGoalDefault
    
    var timeAndUnits: (time: Double, units: String) {
        let time = healthKitController.timeInDaylightWeek
        
        if time > 60 {
            let rounded = Double(round(100 * Double(time) / 60) / 100)
            return (rounded, "Hours")
        } else {
            return (Double(time), "Minutes")
        }
    }
    
    var body: some View {
        HomeStatCard(headerTitle: "Sunlight 7 days", headerImage: sunlightSystemImage, date: healthKitController.latestTimeInDaylight, color: .rest) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Group {
                    if timeAndUnits.units == "Minutes" {
                        Text(Int(timeAndUnits.time), format: .number)
                    } else {
                        Text(timeAndUnits.time, format: .number)
                    }
                }
                .font(.title)
                .fontWeight(.semibold)
                
                Text(timeAndUnits.units)
                    .foregroundStyle(.secondary)
                    .font(.footnote.bold())
            }
            
            Text("\(percentComplete(action: healthKitController.timeInDaylightWeek, goal: dailySunlightGoal)) of \(goalAbbreviated(forWeek: true))")
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
        let goal = Double(forWeek ? dailySunlightGoal * 7 : dailySunlightGoal) / 60
        
        return (goal * 60).secondsAsTimeRoundedToMinutes(units: .short)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.latestTimeInDaylight = .now
    healthKitController.timeInDaylightWeek = 240
    
    return HomeSunlightPastWeek(healthKitController: healthKitController)
}

