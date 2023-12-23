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
    
    @Binding var timeFrame: FTTimeFrame
    
    var averageMinutesPerDay: Int {
        var minutes = 0
        
        let pastWeekMeditates = meditates.filter { isInPast(period: timeFrame, date: $0.startDate) }
        let pastWeekReads = reads.filter { isInPast(period: timeFrame, date: $0.startDate) }
        
        for read in pastWeekReads {
            minutes += read.duration
        }
        
        for meditate in pastWeekMeditates {
            minutes += meditate.duration
        }
        
        minutes /= 60
        let minutesPerDay = Double(minutes) / timeFrame.days()
        
        return Int(minutesPerDay.rounded())
    }
    
    var weekData: [Rest] {
        var data: [Rest] = []
        
        let pastMeditates = meditates.filter { isInPast(period: timeFrame, date: $0.startDate) }
        let pastReads = reads.filter { isInPast(period: timeFrame, date: $0.startDate) }
        
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
        }
        
        return data.sorted { a, b in
            a.type > b.type
        }
    }
    
    var body: some View {
        VStack {
            GroupBox("Past \(timeFrame.labelName()) (avg: \(averageMinutesPerDay) minutes)") {
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
            .padding()
        }
    }
    
    private func day(for date: Date) -> String {
        if timeFrame == .sevenDays {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE"
            let weekday = dateFormatter.string(from: date)
            
            return weekday
        } else if timeFrame == .twoWeeks {
            let day = date.get(.day)
            
            return String(day)
        } else if timeFrame == .sixMonths {
            let month = date.get(.month)
            
            return month.monthName()
        } else {
            let week = date.get(.weekOfYear)
            
            return String(week)
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
