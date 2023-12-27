//
//  HomeStepsView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct HomeSteps: View {
    @Bindable var healthKitController: HealthKitController
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: stepsSystemImage)
                    Text("Steps")
                }
                .foregroundStyle(.move)
                
                Spacer()
                
                Text(healthKitController.latestSteps, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Today")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    Text(healthKitController.stepCountToday, format: .number)
                        .font(.title.weight(.semibold))
                    
                    HStack(spacing: 0) {
                        Text("\(percentComplete(action: healthKitController.stepCountToday, goal: dailyStepsGoal))")
                        
                        Text(" of \(goalAbbreviated())k")
                    }
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("7 days")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    Text(healthKitController.stepCountWeek, format: .number)
                        .font(.title.weight(.semibold))
                    
                    HStack(spacing: 0) {
                        Text("\(percentComplete(action: healthKitController.stepCountWeek, goal: dailyStepsGoal, forWeek: true))")
                        
                        Text(" of \(goalAbbreviated(forWeek: true))k")
                    }
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 2)
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
    let healthKitController = HealthKitController()
    healthKitController.stepCountToday = 9500
    healthKitController.stepCountWeek = 55000
    
    return HomeSteps(healthKitController: healthKitController)
}
