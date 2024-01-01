//
//  SunlightDetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct SunlightDetailView: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        WeekSunlightBarChart(healthKitController: healthKitController)
            .navigationTitle("Time in Sunlight")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                healthKitController.getTimeInDaylightWeekByDay()
            }
    }
}

#Preview {
    SunlightDetailView(healthKitController: HealthKitController())
}
