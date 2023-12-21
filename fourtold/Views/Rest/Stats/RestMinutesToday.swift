//
//  RestMindfulMinutesToday.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/19/23.
//

import SwiftData
import SwiftUI

struct RestMinutesToday: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTMeditate.startDate) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate) var reads: [FTRead]
    
    var dateAndMins: (date: Date, readMinutes: Int, meditateMinutes: Int) {
        var mostRecent: Date = .distantPast
        
        let todayMeditates = meditates.filter { isToday(date: $0.startDate) }
        let todayReads = reads.filter { isToday(date: $0.startDate) }
        
        var readMinutes = 0
        for read in todayReads {
            readMinutes += read.duration
            
            if read.startDate > mostRecent {
                mostRecent = read.startDate
            }
        }
        readMinutes /= 60
        
        var meditateMinutes = 0
        for meditate in todayMeditates {
            meditateMinutes += meditate.duration
            
            if meditate.startDate > mostRecent {
                mostRecent = meditate.startDate
            }
        }
        meditateMinutes /= 60
        
        return (mostRecent, readMinutes, meditateMinutes)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: restSystemImage)
                    
                    Text("Rest today")
                }
                .foregroundStyle(.rest)
                
                Spacer()
                
                Text(dateAndMins.date, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
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
    
    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

#Preview {
    RestMinutesToday()
}
