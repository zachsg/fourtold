//
//  HomeZone2Cards.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct HomeZone2Cards: View {
    @Environment(HealthKitController.self) private var healthKitController
    
    @Binding var zone2TodayPercent: Double
    @Binding var zone2WeekPercent: Double
    
    var body: some View {
        VStack {
            Section {
                NavigationLink {
                    WeekZone2DetailView()
                } label: {
                    HStack {
                        HomeZone2Today(zone2TodayPercent: $zone2TodayPercent)

                        HomeZone2PastWeek(zone2WeekPercent: $zone2WeekPercent)
                    }
                }
            } header: {
                HStack {
                    Image(systemName: vO2SystemImage)
                    Text("Zone 2+ HR")
                    Spacer()
                    dateView(date: healthKitController.latestZone2)
                }
                .font(.headline.bold())
                .foregroundStyle(.sweat)
            }
        }
        .padding()
    }
    
    func dateView(date: Date) -> some View {
        Group {
            if Calendar.current.isDateInYesterday(date) {
                Text("Updated yesterday")
            } else if Calendar.current.isDateInToday(date) {
                Text(date, format: .dateTime.hour().minute())
            } else if date == .distantPast {
                Text("")
            } else  {
                HStack(spacing: 0) {
                    Text("Updated ")
                    Text(date, format: .dateTime.day().month())
                }
            }
        }
        .font(.footnote.bold())
        .foregroundStyle(.secondary)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.zone2Today = 15
    healthKitController.zone2Week = 70
    healthKitController.latestZone2 = .now
    
    return HomeZone2Cards(zone2TodayPercent: .constant(80), zone2WeekPercent: .constant(70))
        .environment(healthKitController)
}
