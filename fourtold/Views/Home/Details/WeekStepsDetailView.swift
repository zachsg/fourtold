//
//  WeekStepsDetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import SwiftUI

struct WeekStepsDetailView: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        WeekStepsBarChart(healthKitController: healthKitController)
            .navigationTitle("Steps")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                healthKitController.getStepCountWeekByDay()
            }
    }
}

#Preview {
    WeekStepsDetailView(healthKitController: HealthKitController())
}
