//
//  SettingsView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct SettingsView: View {
    var appVersion: String {
        UIApplication.appVersion ?? "Unknown"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                SettingsUserInfoGroup()
                
                SettingsBodyGroup()
                
                SettingsMindGroup()
                
                Section {
                    // Any dev info about the app
                } header: {
                    HStack {
                        Spacer()
                        Text("App version: \(appVersion)")
                        Spacer()
                    }
                }
            }
            .navigationTitle(settingsTitle)
        }
    }
}

#Preview {
    SettingsView()
}
