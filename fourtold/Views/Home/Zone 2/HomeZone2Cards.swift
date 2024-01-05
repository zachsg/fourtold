//
//  HomeZone2Cards.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct HomeZone2Cards: View {
    @AppStorage(hasZone2Key) var hasZone2: Bool = hasZone2Default
    
    @Bindable var healthKitController: HealthKitController
    
    @Binding var zone2TodayPercent: Double
    @Binding var zone2WeekPercent: Double
    
    var body: some View {
        if hasZone2 {
            VStack {
                Section {
                    NavigationLink {
                        WeekZone2DetailView(healthKitController: healthKitController)
                    } label: {
                        HStack {
                            HomeZone2Today(healthKitController: healthKitController, zone2TodayPercent: $zone2TodayPercent)
                            
                            HomeZone2PastWeek(healthKitController: healthKitController, zone2WeekPercent: $zone2WeekPercent)
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
    
    return HomeZone2Cards(healthKitController: healthKitController, zone2TodayPercent: .constant(80), zone2WeekPercent: .constant(70))
}
