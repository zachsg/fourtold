//
//  BarChart.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import Charts
import SwiftUI

struct WeekStepsBarChart: View {
    @Bindable var healthKitController: HealthKitController
    
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = 10000
    
    var averageStepsPerDay: Int {
        var cumulative = 0
        var days = 0
        for (_, steps) in healthKitController.stepCountWeekByDay {
            days += 1
            cumulative += steps
        }
        
        return days == 0 ? 0 : cumulative / days
    }
    
    var body: some View {
        VStack {
            GroupBox("Past 7 Days (Avg: \(averageStepsPerDay))") {
                Chart {
                    ForEach(healthKitController.stepCountWeekByDay.sorted { $0.key < $1.key }, id: \.key) { date, steps in
                        BarMark(
                            x: .value("Day", weekDay(for: date)),
                            y: .value("Steps", steps)
                        )
                        .foregroundStyle(steps >= dailyStepsGoal ? .move : .accent)
                        .annotation(position: .top, alignment: .center) {
                            Text(steps, format: .number)
                                .font(Calendar.current.isDateInToday(date) ? .footnote.bold() : .footnote)
                        }
                        .cornerRadius(2)
                    }
                    
                    RuleMark(y: .value("Goal", dailyStepsGoal))
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
            healthKitController.stepCountWeekByDay[date] = Int.random(in: 0...15000)
        }
    }
    
    return WeekStepsBarChart(healthKitController: healthKitController)
}
