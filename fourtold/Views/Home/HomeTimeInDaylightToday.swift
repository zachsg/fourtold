//
//  HomeTimeInDaylightToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/28/23.
//

import SwiftUI

struct HomeTimeInDaylightToday: View {
    @Bindable var healthKitController: HealthKitController
    @AppStorage(dailyTimeInDaylightGoalKey) var dailyTimeInDaylightGoal: Int = dailyTimeInDaylightGoalDefault
    
    var body: some View {
        HomeStatCard(headerTitle: "Daylight today", headerImage: timeInDaylightSystemImage, date: healthKitController.latestTimeInDaylight, color: .rest) {
            HStack(alignment: .firstTextBaseline) {
                Text(healthKitController.timeInDaylightToday, format: .number)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Minutes")
                    .foregroundStyle(.secondary)
                    .font(.subheadline.bold())
            }
            
            Text("\(percentComplete(action: healthKitController.timeInDaylightToday, goal: dailyTimeInDaylightGoal)) of \(goalAbbreviated())min")
                .foregroundStyle(.secondary)
                .font(.subheadline.bold())
        }
    }
    
    func percentComplete(action: Int, goal: Int, forWeek: Bool = false) -> String {
        let percent = (Double(action) / Double(forWeek ? (goal * 7) / 60 : goal / 60) * 100).rounded()
        
        return String(format: "%.0f%%", percent)
    }
    
    func goalAbbreviated(forWeek: Bool = false) -> String {
        let goal = Double(forWeek ? dailyTimeInDaylightGoal * 7 : dailyTimeInDaylightGoal) / 60
        
        return String(Int(goal))
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.latestTimeInDaylight = .now
    healthKitController.timeInDaylightToday = 60
    
    return HomeTimeInDaylightToday(healthKitController: healthKitController)
}
