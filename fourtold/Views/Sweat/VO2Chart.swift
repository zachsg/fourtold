//
//  VO2Chart.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/6/24.
//

import Charts
import SwiftUI

struct VO2Chart: View {
    @Bindable var healthKitController: HealthKitController

    var averageVO2: Double {
        var sum = 0.0
        var count = 0

        for (_, vO2) in healthKitController.cardioFitnessByDay {
            sum += vO2
            count += 1
        }

        sum /= Double(count)

        return (sum * 10).rounded() / 10
    }

    var lowHigh: (low: Double, high: Double) {
        var low = 100.0
        var high = 0.0

        for (_, vO2) in healthKitController.cardioFitnessByDay {
            if vO2 > high {
                high = vO2
            }

            if vO2 < low {
                low = vO2
            }
        }

        low -= 1
        high += 1

        return (low, high)
    }

    var body: some View {
        VStack {
            GroupBox(label:
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("Past 60 Days (avg: ")
                    Text(averageVO2, format: .number)
                        .fontWeight(.bold)
                    Text(" \(vO2Units)")
                        .font(.caption)
                    Text(")")
                }
            ) {
                Chart {
                    ForEach(healthKitController.cardioFitnessByDay.sorted { $0.key < $1.key }, id: \.key) { date, vO2 in
                        LineMark(
                            x: .value("Day", date),
                            y: .value(vO2Units, vO2)
                        )
                        .foregroundStyle(.sweat)
                    }

                    RuleMark(y: .value("Average", averageVO2))
                        .foregroundStyle(.accent.opacity(0.4))
                }
                .chartYScale(domain: lowHigh.low...lowHigh.high)
            }
            .padding()

            Section {
                Text("Your \(vO2Units) (also known as cardio fitness) is the maximum amount of oxygen your body can consume during exercise. A higher \(vO2Units) is an indicator of better cardiovascular fitness and endurance.")
                    .foregroundStyle(.secondary)
            }
            .padding([.leading, .trailing, .bottom])
        }
        .navigationTitle("Cardio Fitness Trend")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let healthKitController = HealthKitController()

    healthKitController.cardioFitnessAverage = 43

    let today: Date = .now
    for i in 0...30 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.cardioFitnessByDay[date] = Double.random(in: 40...45)
        }
    }

    return VO2Chart(healthKitController: healthKitController)
}
