//
//  SettingsBodyGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct SettingsMoveGroup: View {
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = dailyStepsGoalDefault
    @AppStorage(hasZone2Key) var hasZone2: Bool = hasZone2Default
    @AppStorage(dailyZone2GoalKey) var dailyZone2Goal: Int = dailyZone2GoalDefault
    
    var body: some View {
        Section("Daily \(moveTitle) goals") {
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
            .tint(.move)
            
            Group {
                Toggle(isOn: $hasZone2.animation()) {
                    Label(
                        title: {
                            Text("Include Zone 2 HR?")
                        },
                        icon: {
                            Image(systemName: vO2SystemImage)
                                .foregroundStyle(.sweat)
                        }
                    )
                }
                .tint(.sweat)
                
                if hasZone2 {
                    Stepper(value: $dailyZone2Goal, in: 60...7200, step: 60) {
                        Label(
                            title: {
                                HStack(alignment: .firstTextBaseline, spacing: 0) {
                                    Text("Zone 2 goal:")
                                    Text(dailyZone2Goal / 60, format: .number)
                                        .bold()
                                        .padding(.leading, 4)
                                    Text("min")
                                        .font(.footnote)
                                        .padding(.leading, 1)
                                }
                            },
                            icon: {
                                Image(systemName: vO2SystemImage)
                                    .foregroundStyle(.sweat)
                            }
                        )
                    }
                    .tint(.sweat)
                }
            }
        }
    }
}

#Preview {
    SettingsMoveGroup()
}
