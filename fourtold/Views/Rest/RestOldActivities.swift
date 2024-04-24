//
//  RestOldActivities.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/20/23.
//

import SwiftData
import SwiftUI

struct RestOldActivities: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTMeditate.startDate) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate) var reads: [FTRead]
    @Query(sort: \FTBreath.startDate) var breaths: [FTBreath]
    
    @Binding var showOldActivities: Bool
    
    var olderActivities: [any FTActivity] {
        var activities: [any FTActivity] = []
        
        let olderMeditates = meditates.filter { !isToday(date: $0.startDate) }
        let olderReads = reads.filter { !isToday(date: $0.startDate) }
        let olderBreaths = breaths.filter { !isToday(date: $0.startDate) }
        
        activities.append(contentsOf: olderMeditates)
        activities.append(contentsOf: olderReads)
        activities.append(contentsOf: olderBreaths)
        
        return activities.sorted { $0.startDate > $1.startDate }
    }
    
    var body: some View {
        if !olderActivities.isEmpty {
            Section(isExpanded: $showOldActivities) {
                ForEach(olderActivities, id: \.id) { activity in
                    RestItemView(activity: activity)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let activity = olderActivities[index]
                        modelContext.delete(activity)
                    }
                }
            } header: {
                HStack {
                    Text("Older activities")
                    Spacer()
                    Text(olderActivities.count, format: .number)
                        .font(.footnote)
                    Button {
                        withAnimation {
                            showOldActivities.toggle()
                        }
                    } label: {
                        Image(systemName: showOldActivities ? "chevron.down.circle" : "chevron.forward.circle")
                            .foregroundStyle(.rest)
                    }
                }
            }
        }
    }
    
    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

#Preview {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FTMeditate.self,
            FTRead.self,
            FTBreath.self,
            FTTag.self,
            FTTagOption.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return RestOldActivities(showOldActivities: .constant(true))
        .modelContainer(sharedModelContainer)
}
