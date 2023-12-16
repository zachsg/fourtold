//
//  SettingsMindGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct SettingsMindGroup: View {
    @AppStorage(meditateGoalKey) var meditateGoal: Int = 600
    @AppStorage(readGoalKey) var readGoal: Int = 1800
    @AppStorage(breathTypeKey) var breathType: FTBreathType = .four78
    
    var body: some View {
        Section(mindTitle) {
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
                }
            }
        }
    }
}

#Preview {
    SettingsMindGroup()
}
