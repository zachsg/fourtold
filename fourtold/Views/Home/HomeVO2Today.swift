//
//  HomeCardioFitnessToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct HomeVO2Today: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        HomeStatCard(headerTitle: "Cardio fitness", headerImage: vO2SystemImage, date: healthKitController.latestCardioFitness, color: .move) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(String(format: "%.1f%", healthKitController.cardioFitnessMostRecent))
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("VO₂ max")
                    .foregroundStyle(.secondary)
                    .font(.footnote.bold())
            }
        }
    }
    
    func updatedToday() -> Bool {
        return Calendar.current.isDateInToday(healthKitController.latestCardioFitness)
    }
}

#Preview {
    HomeVO2Today(healthKitController: HealthKitController())
}
