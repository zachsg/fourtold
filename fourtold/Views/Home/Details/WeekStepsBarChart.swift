//
//  BarChart.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/4/23.
//

import Charts
import SwiftUI

struct WeekStepsBarChart: View {
    @AppStorage(dailyStepsGoalKey) var dailyStepsGoal: Int = 0
    
    var stepCountWeekByDay: [Date: Int]
    
    var averageStepsPerDay: Int {
        var cumulative = 0
        var days = 0
        for (_, steps) in stepCountWeekByDay {
            days += 1
            cumulative += steps
        }
        
        return days == 0 ? 0 : cumulative / days
    }
    
    var body: some View {
        VStack {
            GroupBox("Past 7 Days (Avg: \(averageStepsPerDay))") {
                Chart {
                    ForEach(stepCountWeekByDay.sorted { $0.key < $1.key }, id: \.key) { date, steps in
                        BarMark(
                            x: .value("Day", weekDay(for: date)),
                            y: .value("Steps", steps)
                        )
                        .foregroundStyle(steps >= dailyStepsGoal ? .red : .blue)
                        .annotation(position: .top, alignment: .center) {
                            Text(steps, format: .number)
                                .font(Calendar.current.isDateInToday(date) ? .footnote.bold() : .footnote)
                        }
                        .cornerRadius(2)
                    }
                    
                    RuleMark(y: .value("Goal", dailyStepsGoal))
                        .foregroundStyle(.red.opacity(0.4))
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
    WeekStepsBarChart(stepCountWeekByDay: [Date.now : 1000])
}
