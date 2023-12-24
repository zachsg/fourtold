//
//  SettingsSweatGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/19/23.
//

import SwiftUI

struct SettingsSweatGroup: View {
    @AppStorage(hasVO2Key) var hasVO2: Bool = hasVO2Default
    
    var body: some View {
        Section(sweatTitle) {
            Toggle(isOn: $hasVO2.animation()) {
                Label(
                    title: {
                        Text("Use cardio fitness?")
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

#Preview {
    SettingsSweatGroup()
}
