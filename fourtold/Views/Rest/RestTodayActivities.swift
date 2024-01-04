//
//  RestActivities.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/20/23.
//

import SwiftData
import SwiftUI

struct RestTodayActivities: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTMeditate.startDate) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate) var reads: [FTRead]
    @Query(sort: \FTBreath.startDate) var breaths: [FTBreath]
    
    @State private var showOldActivities = false
    
    var todayActivities: [any FTActivity] {
        var activities: [any FTActivity] = []
        
        let todayMeditates = meditates.filter { isToday(date: $0.startDate) }
        let todayReads = reads.filter { isToday(date: $0.startDate) }
        let todayBreaths = breaths.filter { isToday(date: $0.startDate) }
        
        activities.append(contentsOf: todayMeditates)
        activities.append(contentsOf: todayReads)
        activities.append(contentsOf: todayBreaths)
        
        return activities.sorted { $0.startDate > $1.startDate }
    }
    
    var body: some View {
        if !todayActivities.isEmpty {
            Section("Activities today") {
                ForEach(todayActivities, id: \.id) { activity in
                    RestItemView(activity: activity)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let activity = todayActivities[index]
                        modelContext.delete(activity)
                    }
                }
            }
        } else {
            HStack {
                Text("It's a new day. Time to take action!")
                Image(systemName: arrowSystemImage)
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(.rest)
                    .font(.title3)
            }
            .font(.headline)
        }
    }
    
    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

#Preview {
    RestTodayActivities()
        .modelContainer(for: [FTMeditate.self, FTRead.self, FTBreath.self])
}
