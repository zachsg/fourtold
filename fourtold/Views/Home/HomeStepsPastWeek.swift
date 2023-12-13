//
//  HomeStepsPastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct HomeStepsPastWeek: View {
    @Bindable var healthKitController: HealthKitController
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = 10000
    
    var body: some View {
        NavigationLink {
            WeekStepsDetailView(healthKitController: healthKitController)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: stepsSystemImage)
                    
                    Text("Steps past 7 days")
                }
                .foregroundStyle(.blue)
                .font(.footnote.bold())
                
                HStack {
                    Text(healthKitController.stepCountWeek, format: .number)
                        .font(.largeTitle.weight(.medium))
                    
                    VStack(alignment: .leading) {
                        Text("\(percentComplete(action: healthKitController.stepCountWeek, goal: dailyStepsGoal * 7))")
                        
                        Text("of \(dailyStepsGoal * 7)")
                    }
                    .font(.footnote.weight(.heavy))
                    .foregroundStyle(.tertiary)
                }
            }
        }
    }
    
    func percentComplete(action: Int, goal: Int) -> String {
        let percent = ((Double(action) / Double(goal)) * 100).rounded()
        
        return String(format: "%.0f%%", percent)
    }
}

#Preview {
    HomeStepsPastWeek(healthKitController: HealthKitController())
}
