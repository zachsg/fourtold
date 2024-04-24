//
//  HomeStepsCards.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import SwiftUI

struct HomeStepsCards: View {
    @Environment(HealthKitController.self) private var healthKitController
    
    @Binding var stepsTodayPercent: Double
    @Binding var stepsWeekPercent: Double
    
    var body: some View {
        VStack {
            Section {
                NavigationLink {
                    WeekStepsDetailView()
                } label: {
                    HStack {
                        HomeStepsToday(stepsTodayPercent: $stepsTodayPercent)
                        
                        HomeStepsPastWeek(stepsWeekPercent: $stepsWeekPercent)
                    }
                }
            } header: {
                HStack {
                    Image(systemName: stepsSystemImage)
                    Text("Steps")
                    Spacer()
                    dateView(date: healthKitController.latestSteps)
                }
                .font(.headline.bold())
                .foregroundStyle(.move)
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
    healthKitController.stepCountToday = 8000
    healthKitController.stepCountWeek = 30000
    healthKitController.latestSteps = .now
    
    return HomeStepsCards(stepsTodayPercent: .constant(80), stepsWeekPercent: .constant(65))
        .environment(healthKitController)
}
