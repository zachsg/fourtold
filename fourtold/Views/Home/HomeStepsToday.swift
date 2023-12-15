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
            
            HStack {
                Text(healthKitController.stepCountToday, format: .number)
                    .font(.largeTitle.weight(.medium))
                
                VStack(alignment: .leading) {
                    Text("\(percentComplete(action: healthKitController.stepCountToday, goal: dailyStepsGoal))")
                    
                    Text("of \(dailyStepsGoal)")
                }
                .font(.footnote.weight(.heavy))
                .foregroundStyle(.tertiary)
            }
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
