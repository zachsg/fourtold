//
//  MoveWalkRunDistanceToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/19/23.
//

import SwiftUI

struct MoveWalkRunDistanceToday: View {
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
                .foregroundColor(moveColor)
                
                Spacer()
                
                Text(healthKitController.latestWalkRunDistance, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(walkRunDistancetoday)
                    .font(.title.weight(.semibold))
                
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
    MoveWalkRunDistanceToday(healthKitController: HealthKitController())
}

