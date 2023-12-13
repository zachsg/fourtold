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
                .foregroundColor(.blue)
                
                Spacer()
                
                Text(healthKitController.latestCardioFitness, format: updatedToday() ? .dateTime.hour().minute() : .dateTime.month().day())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(alignment: .firstTextBaseline) {
                Text(String(format: "%.1f%", healthKitController.cardioFitnessMostRecent))
                    .font(.largeTitle.weight(.medium))
                
//                Text("Miles")
//                    .font(.footnote.weight(.heavy))
//                    .foregroundStyle(.tertiary)
            }
        }
    }
    
    func updatedToday() -> Bool {
        return Calendar.current.isDateInToday(healthKitController.latestCardioFitness)
    }
}

#Preview {
    HomeCardioFitnessToday(healthKitController: HealthKitController())
}
