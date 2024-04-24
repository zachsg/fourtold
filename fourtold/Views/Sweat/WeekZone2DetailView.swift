//
//  WeekZone2DetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct WeekZone2DetailView: View {
    @Environment(HealthKitController.self) private var healthKitController
    
    var body: some View {
        WeekZone2BarChart()
            .navigationTitle("Time in Zone 2+ HR")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                healthKitController.getZone2WeekByDay()
            }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return WeekZone2DetailView()
        .environment(healthKitController)
}
