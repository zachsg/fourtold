//
//  WeekZone2BarChart.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/31/23.
//

import Charts
import SwiftUI

struct WeekZone2BarChart: View {
    @Environment(HealthKitController.self) private var healthKitController
    
    @AppStorage(dailyZone2GoalKey) var dailyZone2Goal: Int = dailyZone2GoalDefault
    
    var averageZone2PerDay: Int {
        var cumulative = 0
        var days = 0
        for (_, minutes) in healthKitController.zone2WeekByDay {
            days += 1
            cumulative += minutes
        }
        
        return days == 0 ? 0 : cumulative / days
    }
    
    var body: some View {
        VStack {
            GroupBox("Past 7 Days (avg: \(averageZone2PerDay)min)") {
                Chart {
                    ForEach(healthKitController.zone2WeekByDay.sorted { $0.key < $1.key }, id: \.key) { date, minutes in
                        BarMark(
                            x: .value("Day", date.weekDay()),
                            y: .value("Minutes", minutes)
                        )
                        .foregroundStyle(minutes >= dailyZone2Goal / 60 ? .sweat : .accent)
                        .annotation(position: .top, alignment: .center) {
                            Text(minutes, format: .number)
                                .font(Calendar.current.isDateInToday(date) ? .footnote.bold() : .footnote)
                        }
                        .cornerRadius(2)
                    }
                    
                    RuleMark(y: .value("Goal", dailyZone2Goal / 60))
                        .foregroundStyle(.sweat.opacity(0.4))
                        .annotation(position: .trailing, alignment: .center) {
                            // Text(12000, format: .number)
                            //    .font(.footnote)
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    let healthKitController = HealthKitController()
    
    let today: Date = .now
    for i in 0...6 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.zone2WeekByDay[date] = Int.random(in: 0...90)
        }
    }
    
    return WeekZone2BarChart()
        .environment(healthKitController)
}
