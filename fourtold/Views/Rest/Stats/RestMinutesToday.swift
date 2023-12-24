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
    @Query(sort: \FTGround.startDate) var grounds: [FTGround]
    @Query(sort: \FTSun.startDate) var suns: [FTSun]
    
    var dateAndMins: (date: Date, readMinutes: Int, meditateMinutes: Int, groundMinutes: Int, sunMinutes: Int) {
        var mostRecent: Date = .distantPast
        
        let todayMeditates = meditates.filter { isToday(date: $0.startDate) }
        let todayReads = reads.filter { isToday(date: $0.startDate) }
        let todayGrounds = grounds.filter { isToday(date: $0.startDate) }
        let todaySuns = suns.filter { isToday(date: $0.startDate) }
        
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
        
        var groundMinutes = 0
        for ground in todayGrounds {
            groundMinutes += ground.duration
            
            if ground.startDate > mostRecent {
                mostRecent = ground.startDate
            }
        }
        groundMinutes /= 60
        
        var sunMinutes = 0
        for sun in todaySuns {
            sunMinutes += sun.duration
            
            if sun.startDate > mostRecent {
                mostRecent = sun.startDate
            }
        }
        sunMinutes /= 60
        
        return (mostRecent, readMinutes, meditateMinutes, groundMinutes, sunMinutes)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: restSystemImage)
                    
                    Text("Rest minutes today")
                }
                .foregroundStyle(.rest)
                
                Spacer()
                
                Text(dateAndMins.date, format: .dateTime.hour().minute())
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.bold())
            
            HStack(alignment: .firstTextBaseline, spacing: 16) {
                VStack {
                    Text("\(dateAndMins.meditateMinutes)")
                        .font(.title.weight(.semibold))
                    
                    Text("Meditate")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                
                VStack {
                    Text("\(dateAndMins.readMinutes)")
                        .font(.title.weight(.semibold))
                    
                    Text("Read")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                
                VStack {
                    Text("\(dateAndMins.groundMinutes)")
                        .font(.title.weight(.semibold))
                    
                    Text("Ground")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                
                VStack {
                    Text("\(dateAndMins.sunMinutes)")
                        .font(.title.weight(.semibold))
                    
                    Text("Sun")
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
