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
                .foregroundColor(.blue)
                
                Spacer()
                
                Text(healthKitController.latestWalkRunDistance, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(alignment: .firstTextBaseline) {
                Text(walkRunDistancetoday)
                    .font(.largeTitle.weight(.medium))
                
                Text("Miles")
                    .font(.footnote.weight(.heavy))
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    HomeWalkRunDistanceToday(healthKitController: HealthKitController())
}
