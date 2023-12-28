//
//  RestStreaks.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/23/23.
//

import SwiftData
import SwiftUI

struct Streak: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let days: Int
}

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
    
    var streaks: [Streak] {
        var s: [Streak] = []
        
        let all = [
            Streak(label: "Meditate", days: meditateStreak),
            Streak(label: "Read", days: readStreak),
        ].sorted { a, b in
            a.days > b.days
        }
        
        for item in all {
            if item.days > 0 {
                s.append(item)
            }
        }
        
        return s
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
                if doesMeditate || doesRead {
                    HStack {
                        ForEach(streaks, id: \.self) { streak in
                            RestStreakItem(label: streak.label, streak: streak.days)
                        }
                    }
                } else {
                    Text("No actions taken yet!")
                        .font(.headline)
                }
            }
            .padding(.top, 4)
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
