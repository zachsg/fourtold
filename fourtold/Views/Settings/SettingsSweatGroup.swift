//
//  SettingsSweatGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/19/23.
//

import SwiftUI

struct SettingsSweatGroup: View {
    @AppStorage(hasVO2Key) var hasVO2: Bool = true
    
    var body: some View {
        Section(sweatTitle) {
            Toggle(isOn: $hasVO2.animation()) {
                Label(
                    title: {
                        Text("Use cardio fitness?")
                    },
                    icon: {
                        Image(systemName: vO2SystemImage)
                            .foregroundStyle(sweatColor)
                    }
                )
            }
            .tint(sweatColor)
        }
    }
}

#Preview {
    SettingsSweatGroup()
}
