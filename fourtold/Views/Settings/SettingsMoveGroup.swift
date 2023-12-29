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
        }
    }
}

#Preview {
    SettingsMoveGroup()
}
