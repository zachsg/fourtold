//
//  RestStreaks.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/23/23.
//

import SwiftData
import SwiftUI

struct RestStreaks: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTMeditate.startDate, order: .reverse) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate, order: .reverse) var reads: [FTRead]
    
    var doesMeditate: Bool {
        !meditates.isEmpty
    }
    
    var doesRead: Bool {
        !reads.isEmpty
    }
    
    var meditateStreak: Int {
        calculateStreak(for: meditates)
    }
    
    var readStreak: Int {
        calculateStreak(for: reads)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: restSystemImage)
                    
                    Text("Rest current streaks")
                }
                .foregroundStyle(.rest)
            }
            .font(.footnote.bold())
            
            ScrollView(.horizontal) {
                HStack {
                    RestStreakItem(label: "Meditate", streak: meditateStreak)
                    
                    RestStreakItem(label: "Read", streak: readStreak)
                }
            }
        }
    }
    
    private func calculateStreak(for activities: [any FTActivity]) -> Int {
        var streak = 0
        
        var compareDay: Date = .now
        var daysAgo = 0
        let dayInSeconds = 86400
        let calendar = Calendar.current
        
        if !activities.isEmpty {
            if calendar.isDateInYesterday(activities.first!.startDate) {
                daysAgo = 1
            }
        }
        
        for activity in activities {
            compareDay = .now.addingTimeInterval(-TimeInterval(dayInSeconds * daysAgo))
            let activityDate = activity.startDate
            
            if calendar.isDate(activityDate, inSameDayAs: compareDay) {
                streak += 1
                daysAgo += 1
            } else if activityDate > compareDay {
            } else if activityDate < compareDay {
                if !calendar.isDateInToday(compareDay) {
                    break
                } else {
                    daysAgo += 1
                }
            }
        }
        
        return streak
    }
}

#Preview {
    return RestStreaks()
}
