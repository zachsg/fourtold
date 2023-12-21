//
//  RestMindfulMinutesPastWeek.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/19/23.
//

import SwiftData
import SwiftUI

struct RestMinutesPastWeek: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTMeditate.startDate) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate) var reads: [FTRead]
    
    @Bindable var healthKitController: HealthKitController
    
    var dateAndMins: (date: Date, readMinutes: Int, meditateMinutes: Int) {
        var mostRecent: Date = .distantPast
        
        let pastWeekMeditates = meditates.filter { isPastWeek(date: $0.startDate) }
        let pastWeekReads = reads.filter { isPastWeek(date: $0.startDate) }
        
        var readMinutes = 0
        for read in pastWeekReads {
            readMinutes += read.duration
            
            if read.startDate > mostRecent {
                mostRecent = read.startDate
            }
        }
        readMinutes /= 60
        
        var meditateMinutes = 0
        for meditate in pastWeekMeditates {
            meditateMinutes += meditate.duration
            
            if meditate.startDate > mostRecent {
                mostRecent = meditate.startDate
            }
        }
        meditateMinutes /= 60
        
        return (mostRecent, readMinutes, meditateMinutes)
    }
    
    var body: some View {
        NavigationLink {
            WeekRestMinutesDetailView()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: restSystemImage)
                        
                        Text("Rest past 7 days")
                    }
                    .foregroundStyle(.rest)
                }
                .font(.footnote.bold())
                
                HStack {
                    HStack(spacing: 0) {
                        Text("\(dateAndMins.readMinutes)")
                            .font(.title.weight(.semibold))
                        
                        VStack(alignment: .leading) {
                            Text("Minutes")
                            Text("Reading")
                        }
                        .padding(.leading, 2)
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    }
                    
                    HStack(spacing: 0) {
                        Text("\(dateAndMins.meditateMinutes)")
                            .font(.title.weight(.semibold))
                        
                        VStack(alignment: .leading) {
                            Text("Minutes")
                            Text("Meditating")
                        }
                        .padding(.leading, 2)
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 2)
            }
        }
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
    RestMinutesPastWeek(healthKitController: HealthKitController())
}
