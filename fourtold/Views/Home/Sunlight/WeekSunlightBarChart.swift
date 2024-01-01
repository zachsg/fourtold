//
//  WeekSunlightBarChart.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import Charts
import SwiftUI

struct WeekSunlightBarChart: View {
    @Bindable var healthKitController: HealthKitController
    
    @AppStorage(dailySunlightGoalKey) var dailySunlightGoal: Int = dailySunlightGoalDefault
    
    var averageSunlightPerDay: Int {
        var cumulative = 0
        var days = 0
        for (_, minutes) in healthKitController.timeInDaylightWeekByDay {
            days += 1
            cumulative += minutes
        }
        
        return days == 0 ? 0 : cumulative / days
    }
    
    var body: some View {
        VStack {
            GroupBox("Past 7 Days (avg: \(averageSunlightPerDay)min)") {
                Chart {
                    ForEach(healthKitController.timeInDaylightWeekByDay.sorted { $0.key < $1.key }, id: \.key) { date, minutes in
                        BarMark(
                            x: .value("Day", weekDay(for: date)),
                            y: .value("Minutes", minutes)
                        )
                        .foregroundStyle(minutes >= dailySunlightGoal / 60 ? .move : .accent)
                        .annotation(position: .top, alignment: .center) {
                            Text(minutes, format: .number)
                                .font(Calendar.current.isDateInToday(date) ? .footnote.bold() : .footnote)
                        }
                        .cornerRadius(2)
                    }
                    
                    RuleMark(y: .value("Goal", dailySunlightGoal / 60))
                        .foregroundStyle(.move.opacity(0.4))
                        .annotation(position: .trailing, alignment: .center) {
                            // Text(12000, format: .number)
                            //    .font(.footnote)
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
            healthKitController.timeInDaylightWeekByDay[date] = Int.random(in: 0...120)
        }
    }
    
    return WeekSunlightBarChart(healthKitController: healthKitController)
}

