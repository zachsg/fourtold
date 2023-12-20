//
//  MoveStepsPastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/19/23.
//

import SwiftUI

struct MoveStepsPastWeek: View {
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
                .foregroundStyle(moveColor)
                .font(.footnote.bold())
                
                HStack(spacing: 0) {
                    Text(healthKitController.stepCountWeek, format: .number)
                        .font(.title.weight(.semibold))
                    
                    VStack(alignment: .leading) {
                        Text("\(percentComplete(action: healthKitController.stepCountWeek, goal: dailyStepsGoal * 7))")
                        
                        Text("of \(dailyStepsGoal * 7)")
                    }
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .padding(.leading, 2)
                }
                .padding(.top, 2)
            }
        }
    }
    
    func percentComplete(action: Int, goal: Int) -> String {
        let percent = ((Double(action) / Double(goal)) * 100).rounded()
        
        return String(format: "%.0f%%", percent)
    }
}

#Preview {
    MoveStepsPastWeek(healthKitController: HealthKitController())
}
