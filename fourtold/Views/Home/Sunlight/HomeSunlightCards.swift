//
//  HomeSunlightCards.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct HomeSunlightCards: View {
    @AppStorage(hasSunlightKey) var hasSunlight: Bool = hasSunlightDefault
    
    @Bindable var healthKitController: HealthKitController
    
    @Binding var sunTodayPercent: Double
    @Binding var sunWeekPercent: Double
    
    var body: some View {
        if hasSunlight {
            VStack {
                Section {
                    NavigationLink {
                        SunlightDetailView(healthKitController: healthKitController)
                    } label: {
                        HStack {
                            HomeSunlightToday(healthKitController: healthKitController, sunTodayPercent: $sunTodayPercent)
                            
                            HomeSunlightPastWeek(healthKitController: healthKitController, sunWeekPercent: $sunWeekPercent)
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: sunlightSystemImage)
                        Text("Sunlight")
                        Spacer()
                        dateView(date: healthKitController.latestTimeInDaylight)
                    }
                    .font(.headline.bold())
                    .foregroundStyle(.rest)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
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
    healthKitController.timeInDaylightToday = 30
    healthKitController.timeInDaylightWeek = 120
    healthKitController.latestTimeInDaylight = .now
    
    return HomeSunlightCards(healthKitController: healthKitController, sunTodayPercent: .constant(50), sunWeekPercent: .constant(70))
}
