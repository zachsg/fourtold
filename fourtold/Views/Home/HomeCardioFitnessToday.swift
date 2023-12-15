//
//  HomeCardioFitnessToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct HomeCardioFitnessToday: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: cardioSystemImage)
                    
                    Text("Latest Cardio Fitness")
                }
                .foregroundColor(.accentColor)
                
                Spacer()
                
                Text(healthKitController.latestCardioFitness, format: updatedToday() ? .dateTime.hour().minute() : .dateTime.month().day())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(String(format: "%.1f%", healthKitController.cardioFitnessMostRecent))
                    .font(.title.bold())
                
                Text("VO₂ max")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .padding(.leading, 2)
            }
            .padding(.top, 2)
        }
    }
    
    func updatedToday() -> Bool {
        return Calendar.current.isDateInToday(healthKitController.latestCardioFitness)
    }
}

#Preview {
    HomeCardioFitnessToday(healthKitController: HealthKitController())
}
