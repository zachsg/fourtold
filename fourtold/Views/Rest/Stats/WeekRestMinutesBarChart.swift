//
//  WeekMindfulMinutesBarChart.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import Charts
import SwiftData
import SwiftUI

struct Rest: Identifiable {
    var id = UUID()
    var date: Date
    var minutes: Int
    var type: String
}

struct WeekRestMinutesBarChart: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \FTMeditate.startDate) var meditates: [FTMeditate]
    @Query(sort: \FTRead.startDate) var reads: [FTRead]
    @Query(sort: \FTBreath.startDate) var breaths: [FTBreath]
    
    @Binding var timeFrame: FTTimeFrame
    
    var meditateMinutes: Int {
        var minutes = 0
        
        let pastMeditates = meditates.filter { isInPast(period: timeFrame, date: $0.startDate) }
        for meditate in pastMeditates {
            minutes += meditate.duration
        }
        
        return minutes / 60
    }
    
    var readMinutes: Int {
        var minutes = 0
        
        let pastReads = reads.filter { isInPast(period: timeFrame, date: $0.startDate) }
        for read in pastReads {
            minutes += read.duration
        }
        
        return minutes / 60
    }
    
    var breathMinutes: Int {
        var minutes = 0
        
        let pastBreaths = breaths.filter { isInPast(period: timeFrame, date: $0.startDate) }
        for breath in pastBreaths {
            minutes += breath.duration
        }
        
        return minutes / 60
    }
    
    var averageMinutesPerDay: Int {
        var minutes = 0

        minutes += meditateMinutes
        minutes += readMinutes
        minutes += breathMinutes
        
        let minutesPerDay = Double(minutes) / timeFrame.days()
        
        return Int(minutesPerDay.rounded())
    }
    
    var weekData: [Rest] {
        var data: [Rest] = []
        
        let pastMeditates = meditates.filter { isInPast(period: timeFrame, date: $0.startDate) }
        let pastReads = reads.filter { isInPast(period: timeFrame, date: $0.startDate) }
        let pastBreaths = breaths.filter { isInPast(period: timeFrame, date: $0.startDate) }
        
        var day = 0.0
        let calendar = Calendar.current
        
        for i in (0...Int(timeFrame.days() - 1)).reversed() {
            day = Double(i) * 86400
            
            let checkDate: Date = .now.addingTimeInterval(-day)
            var minutes = 0
            for meditate in pastMeditates {
                if calendar.isDate(checkDate, equalTo: meditate.startDate, toGranularity: .day) {
                    minutes += meditate.duration
                }
            }
            
            let rest = Rest(date: checkDate, minutes: minutes / 60, type: "Meditate")
            data.append(rest)
            
            minutes = 0
            for read in pastReads {
                if calendar.isDate(checkDate, equalTo: read.startDate, toGranularity: .day) {
                    minutes += read.duration
                }
            }
            
            let rest2 = Rest(date: checkDate, minutes: minutes / 60, type: "Read")
            data.append(rest2)
            
            minutes = 0
            for breath in pastBreaths {
                if calendar.isDate(checkDate, equalTo: breath.startDate, toGranularity: .day) {
                    minutes += breath.duration
                }
            }
            
            let rest3 = Rest(date: checkDate, minutes: minutes / 60, type: "Breathe")
            data.append(rest3)
        }
        
        return data.sorted { a, b in
            a.type < b.type
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Image(systemName: restSystemImage)
                    Text("Rest minutes \(timeFrame.labelName())")
                    Spacer()
                }
                .foregroundStyle(.rest)
                .font(.headline)
                
                HStack {
                    Spacer()
                    StatItem(minutes: breathMinutes, title: "Breathe")
                    Spacer()
                    StatItem(minutes: meditateMinutes, title: "Meditate")
                    Spacer()
                    StatItem(minutes: readMinutes, title: "Read")
                    Spacer()
                }
                .padding(.top, 4)
            }
            .padding(.horizontal)
            .padding(.top, 4)
            
            GroupBox {
                Chart {
                    ForEach(weekData) { rest in
                        BarMark(
                            x: .value("Day", day(for: rest.date)),
                            y: .value("Minutes", rest.minutes)
                        )
                        .foregroundStyle(by: .value("Type", rest.type))
                        .cornerRadius(2)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func day(for date: Date) -> String {
        return if timeFrame == .sevenDays {
            date.weekDay()
        } else if timeFrame == .twoWeeks {
            String(date.get(.day))
        } else if timeFrame == .sixMonths {
            date.get(.month).monthName()
        } else {
            String(date.get(.weekOfYear))
        }
    }
    
    func isInPast(period: FTTimeFrame, date: Date) -> Bool {
        let now: Date = .now
        let dayInSeconds = 86400.0
        let span = timeFrame.days() - 1
        let aWeekAgo = now.addingTimeInterval(dayInSeconds * -span)
        let range = aWeekAgo...now
        
        return range.contains(date)
    }
}

#Preview {
    return WeekRestMinutesBarChart(timeFrame: .constant(.sevenDays))
}
