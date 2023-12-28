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
        HomeStatCard(headerTitle: "Distance today", headerImage: distanceSystemImage, date: healthKitController.latestWalkRunDistance, color: .move) {
            Text(walkRunDistancetoday)
                .font(.title.bold())
            
            Text("Miles")
                .foregroundStyle(.secondary)
                .font(.headline)
        }
    }
}

#Preview {
    HomeWalkRunDistanceToday(healthKitController: HealthKitController())
}
