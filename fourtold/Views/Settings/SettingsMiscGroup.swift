//
//  SettingsMiscGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/30/23.
//

import SwiftUI

struct SettingsMiscGroup: View {
    @AppStorage(userAgeKey) var userAge: Int = userAgeDefault
    @AppStorage(zone2ThresholdKey) var zone2Threshold: Int = zone2ThresholdDefault
    @AppStorage(hasVO2Key) var hasVO2: Bool = hasVO2Default
    
    var zone2Rec: Int {
        let max = Double(220 - userAge)
        return Int((max * 0.7).rounded())
    }
    
    var body: some View {
        Section {
            Stepper(value: $zone2Threshold, in: 90...160, step: 1) {
                Label(
                    title: {
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("Zone 2 starts:")
                            Text(zone2Threshold, format: .number)
                                .bold()
                                .padding(.leading, 4)
                            Text("bpm")
                                .font(.footnote)
                                .padding(.leading, 1)
                        }
                    },
                    icon: {
                        Image(systemName: vO2SystemImage)
                            .foregroundStyle(.move)
                    }
                )
            }
            .tint(.move)
            
            Toggle(isOn: $hasVO2.animation()) {
                Label(
                    title: {
                        Text("Include cardio fitness?")
                    },
                    icon: {
                        Image(systemName: vO2SystemImage)
                            .foregroundStyle(.move)
                    }
                )
            }
            .tint(.move)
        } header: {
            Text("Misc.")
        } footer: {
            Text("Your recommended Zone 2 heart rate lower bound is \(zone2Rec) beats/min.")
        }
    }
}

#Preview {
    SettingsMiscGroup()
}
