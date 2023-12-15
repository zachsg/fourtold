//
//  HomeStepsView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct HomeStepsToday: View {
    @Bindable var healthKitController: HealthKitController
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = 10000
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: stepsSystemImage)
                    Text("Steps today")
                }
                .foregroundColor(.accentColor)
                
                Spacer()
                
                Text(healthKitController.latestSteps, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(spacing: 0) {
                Text(healthKitController.stepCountToday, format: .number)
                    .font(.title.weight(.semibold))
                
                VStack(alignment: .leading) {
                    Text("\(percentComplete(action: healthKitController.stepCountToday, goal: dailyStepsGoal))")
                    
                    Text("of \(dailyStepsGoal)")
                }
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .padding(.leading, 2)
            }
            .padding(.top, 2)
        }
    }
    
    func percentComplete(action: Int, goal: Int) -> String {
        let percent = ((Double(action) / Double(goal)) * 100).rounded()
        
        return String(format: "%.0f%%", percent)
    }
}

#Preview {
    HomeStepsToday(healthKitController: HealthKitController())
}
