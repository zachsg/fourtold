//
//  WeekZone2DetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct WeekZone2DetailView: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        WeekZone2BarChart(healthKitController: healthKitController)
            .navigationTitle("Time in Zone 2+ HR")
            .navigationBarTitleDisplayMode(.inline)
            .task {
//                healthKitController.getZone2WeekByDay()
            }
    }
}

#Preview {
    WeekZone2DetailView(healthKitController: HealthKitController())
}
