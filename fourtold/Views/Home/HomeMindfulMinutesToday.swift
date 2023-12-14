//
//  HomeMindfulMinutesToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import SwiftUI

struct HomeMindfulMinutesToday: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: mindSystemImage)
                    
                    Text("Mindfulness today")
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                Text(healthKitController.latestSteps, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(alignment: .firstTextBaseline) {
                Text("\(healthKitController.mindfulMinutesToday)")
                    .font(.largeTitle.weight(.medium))
                
                Text("Minutes")
                    .font(.footnote.weight(.heavy))
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    HomeMindfulMinutesToday(healthKitController: HealthKitController())
}
