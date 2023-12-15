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
                    .foregroundColor(.accentColor)
                }
                .font(.footnote.bold())
                
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("\(healthKitController.mindfulMinutesWeek)")
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
}

#Preview {
    HomeMindfulMinutesToday(healthKitController: HealthKitController())
}
