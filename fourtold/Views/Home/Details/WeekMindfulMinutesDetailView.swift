//
//  WeekMindfulMinutesDetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import SwiftUI

struct WeekMindfulMinutesDetailView: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        WeekMindfulMinutesBarChart(mindfulMinutesWeekByDay: healthKitController.mindfulMinutesWeekByDay)
            .navigationTitle("Mindful Minutes")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                healthKitController.getMindfulMinutesWeekByDay()
            }
    }
}

#Preview {
    WeekStepsDetailView(healthKitController: HealthKitController())
}

