//
//  HomeMindfulMinutesToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import SwiftUI

struct HomeMindfulMinutesToday: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        HomeStatCard(headerTitle: "Mindfulness today", headerImage: restSystemImage, date: healthKitController.latestMindfulMinutes, color: .rest) {
            Text("\(healthKitController.mindfulMinutesToday)")
                .font(.title.bold())
            
            Text("Minutes")
                .foregroundStyle(.secondary)
                .font(.headline)
        }
    }
}

#Preview {
    HomeMindfulMinutesToday(healthKitController: HealthKitController())
}
