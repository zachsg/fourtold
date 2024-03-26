//
//  SettingsMindGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct SettingsRestGroup: View {
    @AppStorage(dailyMindfulnessGoalKey) var dailyMindfulnessGoal: Int = dailyMindfulnessGoalDefault
    @AppStorage(dailySunlightGoalKey) var dailySunlightGoal: Int = dailySunlightGoalDefault
    
    var body: some View {
        Section {
            Stepper(value: $dailyMindfulnessGoal, in: 60...10800, step: 60) {
                Label(
                    title: {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("Mindful goal:")
                            Text(dailyMindfulnessGoal / 60, format: .number)
                                .bold()
                                .padding(.leading, 4)
                            Text("min")
                                .font(.footnote)
                                .padding(.leading, 1)
                        }
                    },
                    icon: {
                        Image(systemName: restSystemImage)
                            .foregroundStyle(.rest)
                    }
                )
            }
            .tint(.rest)
        } header: {
            Text("Daily \(restTitle) goals")
        } footer: {
            Text("Contributors: Meditation and breathwork minutes.")
        }
    }
}

#Preview {
    SettingsRestGroup()
}
