//
//  SettingsBodyGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct SettingsMoveGroup: View {
    // Steps
    @AppStorage(hasDailyStepsGoalKey) var hasDailyStepsGoal: Bool = true
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = 10000
    
    // Distance
    @AppStorage(hasWalkRunDistanceKey) var hasWalkRunDistance: Bool = true
    
    var body: some View {
        Section(moveTitle) {
            Toggle(isOn: $hasDailyStepsGoal.animation()) {
                Label("Use steps metrics?", systemImage: stepsSystemImage)
            }
            
            if hasDailyStepsGoal {
                Stepper(value: $dailyStepsGoal, in: 2000...30000, step: 500) {
                    Label(
                        title: {
                            HStack {
                                Text("Steps goal:")
                                
                                Text(dailyStepsGoal, format: .number)
                                    .bold()
                            }
                        },
                        icon: {
                            Image(systemName: stepsSystemImage)
                        }
                    )
                }
            }
            
            Toggle(isOn: $hasWalkRunDistance.animation()) {
                Label("Use distance metrics?", systemImage: distanceSystemImage)
            }
        }
    }
}

#Preview {
    SettingsMoveGroup()
}
