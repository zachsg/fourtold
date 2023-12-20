//
//  WeekMindfulMinutesBarChart.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/13/23.
//

import Charts
import SwiftUI

struct WeekMindfulMinutesBarChart: View {
    @Bindable var healthKitController: HealthKitController
    
    var averageMinutesPerDay: Int {
        var cumulative = 0
        var days = 0
        for (_, steps) in healthKitController.mindfulMinutesWeekByDay {
            days += 1
            cumulative += steps
        }
        
        return days == 0 ? 0 : cumulative / days
    }
    
    var highestMinutes: Int {
        var highest = 0
        for (_, minutes) in healthKitController.mindfulMinutesWeekByDay {
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
                    ForEach(healthKitController.mindfulMinutesWeekByDay.sorted { $0.key < $1.key }, id: \.key) { date, minutes in
                        BarMark(
                            x: .value("Day", weekDay(for: date)),
                            y: .value("Minutes", minutes)
                        )
                        .foregroundStyle(restColor)
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
    let healthKitController = HealthKitController()
    
    let today: Date = .now
    for i in 0...6 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.mindfulMinutesWeekByDay[date] = Int.random(in: 0...20)
        }
    }
    
    return WeekMindfulMinutesBarChart(healthKitController: healthKitController)
}
