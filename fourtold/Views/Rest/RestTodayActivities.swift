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
    
    @Binding var showingOptions: Bool
    
    @State private var showOldActivities = false
    
    var todayActivities: [any FTActivity] {
        var activities: [any FTActivity] = []
        
        let todayMeditates = meditates.filter { isToday(date: $0.startDate) }
        let todayReads = reads.filter { isToday(date: $0.startDate) }
        
        activities.append(contentsOf: todayMeditates)
        activities.append(contentsOf: todayReads)
        
        return activities.sorted { $0.startDate > $1.startDate }
    }
    
    var body: some View {
        if !todayActivities.isEmpty {
            Section("Today") {
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
                Image(systemName: "plus.circle")
                    .foregroundStyle(.rest)
                    .font(.title3)
            }
            .onTapGesture(perform: {
                withAnimation {
                    showingOptions.toggle()
                }
            })
            .font(.headline)
        }
    }
    
    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

#Preview {
    RestTodayActivities(showingOptions: .constant(false))
        .modelContainer(for: [FTMeditate.self, FTRead.self])
}
