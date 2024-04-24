//
//  RHRBadge.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/11/24.
//

import SwiftUI

struct RHRBadge: View {
    @Environment(HKController.self) private var hkController

    var trend: FTRHRTrend {
        let rhrAverage = hkController.rhrAverage
        let rhrCurrent = hkController.rhrMostRecent

        return rhrCurrent.rhrTrend(given: rhrAverage)
    }

    var badgeParts: Text {
        let rhrAverage = hkController.rhrAverage
        let rhrCurrent = hkController.rhrMostRecent
        let trend = rhrCurrent.rhrTrend(given: rhrAverage)

        let main = Text(trend.rawValue.capitalized)

        return main
    }

    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                badgeParts
                    .fontWeight(.bold)
                    .foregroundStyle(trend == .improving ? .sweat : trend == .worsening ? .yellow : .accent)
            }

            Image(systemName: progressSystemImage)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(trend == .improving ? .sweat : trend == .worsening ? .yellow : .accent)
                .rotationEffect(.degrees(trend == .improving ? 135 : trend == .worsening ? 45 : 90))
        }
        .foregroundStyle(.secondary)
        .font(.caption)
    }
}

#Preview {
    let hkController = HKController()
    hkController.rhrMostRecent = 58
    hkController.rhrAverage = 60
    hkController.latestRhr = .now

    return RHRBadge()
        .environment(hkController)
}
