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
                Label(
                    title: {
                        Text("Use steps metrics?")
                    },
                    icon: {
                        Image(systemName: stepsSystemImage)
                            .foregroundStyle(.move)
                    }
                )
            }
            .tint(.move)
            
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
                                .foregroundStyle(.move)
                        }
                    )
                }
            }
            
            Toggle(isOn: $hasWalkRunDistance.animation()) {
                Label(
                    title: {
                        Text("Use distance metrics?")
                    },
                    icon: {
                        Image(systemName: distanceSystemImage)
                            .foregroundStyle(.move)
                    }
                )
            }
            .tint(.move)
        }
    }
}

#Preview {
    SettingsMoveGroup()
}
