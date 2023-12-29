//
//  SettingsBodyGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct SettingsMoveGroup: View {
    // Steps
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    
    // Cardio fitness
    @AppStorage(hasVO2Key) var hasVO2: Bool = hasVO2Default
    
    var body: some View {
        Section(moveTitle) {
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
            
            Toggle(isOn: $hasVO2.animation()) {
                Label(
                    title: {
                        Text("Use cardio fitness?")
                    },
                    icon: {
                        Image(systemName: vO2SystemImage)
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
