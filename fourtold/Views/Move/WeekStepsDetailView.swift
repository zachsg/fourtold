//
//  WeekStepsDetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import SwiftUI

struct WeekStepsDetailView: View {
    @Environment(HealthKitController.self) private var healthKitController
    
    var body: some View {
        WeekStepsBarChart()
            .navigationTitle("Steps")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                healthKitController.getStepCountWeekByDay()
            }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    return WeekStepsDetailView()
        .environment(healthKitController)
}
