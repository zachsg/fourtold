//
//  HomeMindfulMinutesPastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import SwiftUI

struct HomeMindfulMinutesPastWeek: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        NavigationLink {
            WeekMindfulMinutesDetailView(healthKitController: healthKitController)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: mindSystemImage)
                        
                        Text("Mindfulness past 7 days")
                    }
                    .foregroundColor(.blue)
                }
                .font(.footnote.bold())
                
                HStack(alignment: .firstTextBaseline) {
                    Text("\(healthKitController.mindfulMinutesWeek)")
                        .font(.largeTitle.weight(.medium))
                    
                    Text("Minutes")
                        .font(.footnote.weight(.heavy))
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }
}

#Preview {
    HomeMindfulMinutesToday(healthKitController: HealthKitController())
}
