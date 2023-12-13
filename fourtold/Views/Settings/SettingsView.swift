//
//  SettingsView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                SettingsUserInfoGroup()
                
                SettingsBodyGroup()
                
                SettingsMindGroup()
                
                SettingsLifeGroup()
            }
            .navigationTitle(settingsTitle)
        }
    }
}

#Preview {
    SettingsView()
}
