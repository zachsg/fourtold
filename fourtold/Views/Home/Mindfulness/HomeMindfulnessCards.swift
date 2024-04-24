//
//  HomeMindfulnessCards.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct HomeMindfulnessCards: View {
    @Environment(HKController.self) private var hkController
    
    @Binding var mindfulTodayPercent: Double
    @Binding var mindfulWeekPercent: Double
    
    var body: some View {
        VStack {
            Section {
                NavigationLink {
                    WeekRestMinutesDetailView()
                } label: {
                    HStack {
                        HomeMindfulnessToday(mindfulTodayPercent: $mindfulTodayPercent)
                        
                        HomeMindfulnessPastWeek(mindfulWeekPercent: $mindfulWeekPercent)
                    }
                }
            } header: {
                HStack {
                    Image(systemName: restSystemImage)
                    Text("Mindfulness")
                    Spacer()
                    dateView(date: hkController.latestMindfulMinutes)
                }
                .font(.headline.bold())
                .foregroundStyle(.rest)
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
    let hkController = HKController()
    hkController.mindfulMinutesToday = 15
    hkController.mindfulMinutesWeek = 70
    hkController.latestMindfulMinutes = .now
    
    return HomeMindfulnessCards(mindfulTodayPercent: .constant(15), mindfulWeekPercent: .constant(60))
        .environment(hkController)
}
