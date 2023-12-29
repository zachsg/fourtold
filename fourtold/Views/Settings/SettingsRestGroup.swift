//
//  SettingsMindGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct SettingsRestGroup: View {
    @AppStorage(meditateGoalKey) var meditateGoal: Int = meditateGoalDefault
    @AppStorage(readGoalKey) var readGoal: Int = readGoalDefault
    @AppStorage(sunGoalKey) var sunGoal: Int = sunGoalDefault
    @AppStorage(groundGoalKey) var groundGoal: Int = groundGoalDefault
    @AppStorage(breathTypeKey) var breathType: FTBreathType = breathTypeDefault
    @AppStorage(hasTimeInDaylightKey) var hasTimeInDaylight: Bool = true
    @AppStorage(dailyTimeInDaylightGoalKey) var dailyTimeInDaylight: Int = dailyTimeInDaylightGoalDefault
    
    var body: some View {
        Section(restTitle) {
            Toggle(isOn: $hasTimeInDaylight.animation()) {
                Label(
                    title: {
                        Text("Use time in daylight metrics?")
                    },
                    icon: {
                        Image(systemName: timeInDaylightSystemImage)
                            .foregroundStyle(.rest)
                    }
                )
            }
            .tint(.rest)
            
            if hasTimeInDaylight {
                Stepper(value: $dailyTimeInDaylight, in: 60...10800, step: 60) {
                    Label(
                        title: {
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text("Daylight goal:")
                                Text(dailyTimeInDaylight / 60, format: .number)
                                    .bold()
                                    .padding(.leading, 4)
                                Text("min")
                                    .font(.footnote)
                                    .padding(.leading, 1)
                            }
                        },
                        icon: {
                            Image(systemName: timeInDaylightSystemImage)
                                .foregroundStyle(.rest)
                        }
                    )
                }
            }
            
            Stepper(value: $meditateGoal, in: 60...5400, step: 60) {
                Label(
                    title: {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("Meditate goal:")
                            Text(meditateGoal / 60, format: .number)
                                .bold()
                                .padding(.leading, 4)
                            Text("min")
                                .font(.footnote)
                                .padding(.leading, 1)
                        }
                    },
                    icon: {
                        Image(systemName: meditateSystemImage)
                            .foregroundStyle(.rest)
                    }
                )
            }
            
            Stepper(value: $readGoal, in: 300...7200, step: 300) {
                Label(
                    title: {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("Read goal:")
                            Text(readGoal / 60, format: .number)
                                .bold()
                                .padding(.leading, 4)
                            Text("min")
                                .font(.footnote)
                                .padding(.leading, 1)
                        }
                    },
                    icon: {
                        Image(systemName: readSystemImage)
                            .foregroundStyle(.rest)
                    }
                )
            }
            
            Stepper(value: $sunGoal, in: 300...7200, step: 300) {
                Label(
                    title: {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("Sunlight goal:")
                            Text(sunGoal / 60, format: .number)
                                .bold()
                                .padding(.leading, 4)
                            Text("min")
                                .font(.footnote)
                                .padding(.leading, 1)
                        }
                    },
                    icon: {
                        Image(systemName: sunSystemImage)
                            .foregroundStyle(.rest)
                    }
                )
            }
            
            Stepper(value: $groundGoal, in: 300...7200, step: 300) {
                Label(
                    title: {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("Ground goal:")
                            Text(groundGoal / 60, format: .number)
                                .bold()
                                .padding(.leading, 4)
                            Text("min")
                                .font(.footnote)
                                .padding(.leading, 1)
                        }
                    },
                    icon: {
                        Image(systemName: groundSystemImage)
                            .foregroundStyle(.rest)
                    }
                )
            }
            
            Picker(selection: $breathType) {
                ForEach(FTBreathType.allCases, id: \.self) {
                    switch($0) {
                    case .four78:
                        Text("4-7-8 breath")
                    case .box:
                        Text("Box breath")
                    case .wimHof:
                        Text("Wim Hof method")
                    }
                }
            } label: {
                Label {
                    Text("Breath type")
                } icon: {
                    Image(systemName: breathSystemImage)
                        .foregroundStyle(.rest)
                }
            }
            .tint(.rest)
        }
    }
}

#Preview {
    SettingsRestGroup()
}
