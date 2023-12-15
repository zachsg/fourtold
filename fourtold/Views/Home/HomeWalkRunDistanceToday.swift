//
//  HomeWalkRunDistanceSection.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import SwiftUI

struct HomeWalkRunDistanceToday: View {
    @Bindable var healthKitController: HealthKitController
    
    var walkRunDistancetoday: String {
        String(format: "%.2f%", healthKitController.walkRunDistanceToday)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: distanceSystemImage)
                    
                    Text("Distance today")
                }
                .foregroundColor(.accentColor)
                
                Spacer()
                
                Text(healthKitController.latestWalkRunDistance, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(walkRunDistancetoday)
                    .font(.title.bold())
                
                Text("Miles")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .padding(.leading, 2)
            }
            .padding(.top, 2)
        }
    }
}

#Preview {
    HomeWalkRunDistanceToday(healthKitController: HealthKitController())
}
