//
//  SettingsSweatGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/3/24.
//

import SwiftUI

struct SettingsSweatGroup: View {
    @AppStorage(hasZone2Key) var hasZone2: Bool = hasZone2Default
    @AppStorage(dailyZone2GoalKey) var dailyZone2Goal: Int = dailyZone2GoalDefault
    
    var body: some View {
        Section("Daily \(sweatTitle) goals") {
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
    SettingsSweatGroup()
}
