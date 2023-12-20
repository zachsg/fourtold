//
//  RestMindfulMinutesToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/19/23.
//

import SwiftUI

struct RestMindfulMinutesToday: View {
    @Bindable var healthKitController: HealthKitController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: restSystemImage)
                    
                    Text("Mindfulness today")
                }
                .foregroundStyle(restColor)
                
                Spacer()
                
                Text(healthKitController.latestMindfulMinutes, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("\(healthKitController.mindfulMinutesToday)")
                    .font(.title.weight(.semibold))
                
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
    RestMindfulMinutesToday(healthKitController: HealthKitController())
}
