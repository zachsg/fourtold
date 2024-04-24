//
//  WeekStepsDetailView.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/2/23.
//

import SwiftUI

struct WeekStepsDetailView: View {
    @Environment(HKController.self) private var hkController
    
    var body: some View {
        WeekStepsBarChart()
            .navigationTitle("Steps")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                hkController.getStepCountWeekByDay()
            }
    }
}

#Preview {
    let hkController = HKController()
    
    return WeekStepsDetailView()
        .environment(hkController)
}
