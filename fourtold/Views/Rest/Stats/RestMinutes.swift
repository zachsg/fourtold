//
//  RestMinutes.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/24/23.
//

import SwiftData
import SwiftUI

struct RestMinutes: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTMeditate.startDate) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate) var reads: [FTRead]
    @Query(sort: \FTBreath.startDate) var breaths: [FTBreath]
    
    var minToday: Int {
        var minutes = 0
        
        let todayMeditates = meditates.filter { isToday(date: $0.startDate) }
        let todayReads = reads.filter { isToday(date: $0.startDate) }
        let todayBreaths = breaths.filter { isToday(date: $0.startDate) }
        
        for read in todayReads {
            minutes += read.duration
        }
        
        for meditate in todayMeditates {
            minutes += meditate.duration
        }
        
        for breath in todayBreaths {
            minutes += breath.duration
        }
        
        return minutes / 60
    }
    
    var dateAndMinPastWeek: (date: Date, minutes: Int) {
        var mostRecent: Date = .distantPast
        var minutes = 0
        
        let pastWeekMeditates = meditates.filter { isPastWeek(date: $0.startDate) }
        let pastWeekReads = reads.filter { isPastWeek(date: $0.startDate) }
        let pastWeekBreaths = breaths.filter { isPastWeek(date: $0.startDate) }
        
        for read in pastWeekReads {
            minutes += read.duration
            
            if read.startDate > mostRecent {
                mostRecent = read.startDate
            }
        }
        
        for meditate in pastWeekMeditates {
            minutes += meditate.duration
            
            if meditate.startDate > mostRecent {
                mostRecent = meditate.startDate
            }
        }
        
        for breath in pastWeekBreaths{
            minutes += breath.duration
            
            if breath.startDate > mostRecent {
                mostRecent = breath.startDate
            }
        }
        
        return (mostRecent, minutes / 60)
    }
    
    var body: some View {
        NavigationLink {
            WeekRestMinutesDetailView()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: restSystemImage)
                        
                        Text("Rest minutes")
                    }
                    .foregroundStyle(.rest)
                    
                    Spacer()
                    
                    if dateAndMinPastWeek.date != .distantPast {
                        Text(dateAndMinPastWeek.date, format: Calendar.current.isDateInToday(dateAndMinPastWeek.date) ? .dateTime.hour().minute() : .dateTime.day().month())
                            .foregroundStyle(.tertiary)
                    }
                }
                .font(.footnote.bold())
                
                HStack(spacing: 32) {
                    VStack {
                        Text("\(minToday)")
                            .font(.title.weight(.semibold))
                        
                        Text("Today")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack {
                        Text("\(dateAndMinPastWeek.minutes)")
                            .font(.title.weight(.semibold))
                        
                        Text("7 days")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 4)
            }
        }
    }
    
    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func isPastWeek(date: Date) -> Bool {
        let now: Date = .now
        let dayInSeconds = 86400.0
        let aWeekAgo = now.addingTimeInterval(dayInSeconds * -6)
        let range = aWeekAgo...now
        
        return range.contains(date)
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
    
    return RestMinutes()
        .modelContainer(sharedModelContainer)
}
