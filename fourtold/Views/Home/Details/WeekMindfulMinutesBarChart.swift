//
//  WeekMindfulMinutesBarChart.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import Charts
import SwiftUI

struct WeekMindfulMinutesBarChart: View {
    var mindfulMinutesWeekByDay: [Date: Int]
    
    var averageMinutesPerDay: Int {
        var cumulative = 0
        var days = 0
        for (_, steps) in mindfulMinutesWeekByDay {
            days += 1
            cumulative += steps
        }
        
        return days == 0 ? 0 : cumulative / days
    }
    
    var highestMinutes: Int {
        var highest = 0
        for (_, minutes) in mindfulMinutesWeekByDay {
            if minutes > highest {
                highest = minutes
            }
        }
        
        return highest
    }
    
    var body: some View {
        VStack {
            GroupBox("Past 7 Days (Avg: \(averageMinutesPerDay) minutes)") {
                Chart {
                    ForEach(mindfulMinutesWeekByDay.sorted { $0.key < $1.key }, id: \.key) { date, minutes in
                        BarMark(
                            x: .value("Day", weekDay(for: date)),
                            y: .value("Minutes", minutes)
                        )
                        .annotation(position: .top, alignment: .center) {
                            Text(minutes, format: .number)
                                .font(Calendar.current.isDateInToday(date) ? .footnote.bold() : .footnote)
                        }
                        .cornerRadius(2)
                    }
                }
            }
            .padding()
        }
    }
    
    private func weekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekday = dateFormatter.string(from: date)
        
        return weekday
    }
}

#Preview {
    WeekStepsBarChart(stepCountWeekByDay: [Date.now : 1000])
}
