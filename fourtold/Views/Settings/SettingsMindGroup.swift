//
//  SettingsMindGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct SettingsMindGroup: View {
    @AppStorage(meditateGoalKey) var meditateGoal: Int = 600
    
    var body: some View {
        Section(mindTitle) {
            Stepper(value: $meditateGoal, in: 60...5400, step: 60) {
                Label(
                    title: {
                        HStack {
                            Text("Meditate for:")
                            
                            Text(meditateGoal / 60, format: .number)
                                .bold()
                            
                            Text("min")
                                .font(.footnote)
                        }
                    },
                    icon: {
                        Image(systemName: meditateSystemImage)
                    }
                )
            }
        }
    }
}

#Preview {
    SettingsMindGroup()
}
