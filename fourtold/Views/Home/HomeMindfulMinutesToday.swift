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
                .foregroundColor(.accentColor)
                
                Spacer()
                
                Text(healthKitController.latestMindfulMinutes, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("\(healthKitController.mindfulMinutesToday)")
                    .font(.title.bold())
                
                Text("Minutes")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .padding(.leading, 2)
            }
            .padding(.top, 2)
        }
    }
}

#Preview {
    HomeMindfulMinutesToday(healthKitController: HealthKitController())
}
