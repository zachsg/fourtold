//
//  RHRChart.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/11/24.
//

import Charts
import SwiftUI

struct RHRChart: View {
    @Bindable var healthKitController: HealthKitController

    var averageRhr: Int {
        var sum = 0
        var count = 0

        for (_, rhr) in healthKitController.rhrByDay {
            sum += rhr
            count += 1
        }

        let average = Double(sum) / Double(count)

        return Int((average * 100).rounded() / 100)
    }

    var lowHigh: (low: Int, high: Int) {
        var low = 120
        var high = 0

        for (_, rhr) in healthKitController.rhrByDay {
            if rhr > high {
                high = rhr
            }

            if rhr < low {
                low = rhr
            }
        }

        low -= 4
        high += 4

        return (low, high)
    }

    var body: some View {
        VStack {
            GroupBox(label:
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("Past 60 Days (avg: ")
                Text(averageRhr, format: .number)
                    .fontWeight(.bold)
                Text(" \(heartUnits)")
                    .font(.caption)
                Text(")")
            }
            ) {
                Chart {
                    ForEach(healthKitController.rhrByDay.sorted { $0.key < $1.key }, id: \.key) { date, rhr in
                        PointMark(
                            x: .value("Day", date),
                            y: .value(heartUnits, rhr)
                        )
                        .foregroundStyle(.sweat)
                    }

                    RuleMark(y: .value("Average", averageRhr))
                        .foregroundStyle(.accent.opacity(0.4))
                }
                .chartYScale(domain: lowHigh.low...lowHigh.high)
            }
            .padding()

            Section {
                Text("Your resting hear rate is the average number of times your heart beats per minute while you are inactive or at rest. Lower resting heart rates are generally a sign of higher cardiovascular fitness.")
                    .foregroundStyle(.secondary)
            }
            .padding([.leading, .trailing, .bottom])
        }
        .navigationTitle("Resting Heart Rate Trend")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let healthKitController = HealthKitController()

    healthKitController.rhrAverage = 63

    let today: Date = .now
    for i in 0...30 {
        let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
        if let date {
            healthKitController.rhrByDay[date] = Int.random(in: 60...70)
        }
    }

    return RHRChart(healthKitController: healthKitController)
}
