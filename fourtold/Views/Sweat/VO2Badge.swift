//
//  VO2Badge.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/6/24.
//

import SwiftUI

struct VO2Badge: View {
    @Environment(HKController.self) private var hkController

    var trend: FTVO2Trend {
        let vO2Average = hkController.cardioFitnessAverage
        let vO2Current = hkController.cardioFitnessMostRecent

        return vO2Current.vO2Trend(given: vO2Average)
    }

    var badgeParts: (main: Text, sub: Text, subJoiner: Text) {
        let vO2Average = hkController.cardioFitnessAverage
        let vO2Current = hkController.cardioFitnessMostRecent
        let trend = vO2Current.vO2Trend(given: vO2Average)

        let main = Text(vO2Current.vO2Status().rawValue.capitalized)

        var sub: Text
        var subJoiner: Text
        if trend == .worsening {
            subJoiner = Text("but")
            sub = Text(trend.rawValue.capitalized)
        } else if trend == .improving {
            subJoiner = Text("and")
            sub = Text(trend.rawValue.capitalized)
        } else {
            subJoiner = Text("and")
            sub = Text(trend.rawValue.capitalized)
        }

        return (main, sub, subJoiner)
    }

    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                badgeParts.main
                    .fontWeight(.bold)
                    .foregroundStyle(vo2Color())
                HStack(spacing: 4) {
                    badgeParts.subJoiner
                    badgeParts.sub
                        .fontWeight(.bold)
                        .foregroundStyle(trend == .improving ? .sweat : trend == .worsening ? .yellow : .accent)
                }
            }

            Image(systemName: progressSystemImage)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(trend == .improving ? .sweat : trend == .worsening ? .yellow : .accent)
                .rotationEffect(.degrees(trend == .improving ? 45 : trend == .worsening ? 135 : 90))
        }
        .foregroundStyle(.secondary)
        .font(.caption)
    }

    func vo2Color() -> Color {
        let vO2Current = hkController.cardioFitnessMostRecent
        let status = vO2Current.vO2Status()

        return switch status {
        case .veryPoor:
                .red
        case .poor:
                .pink
        case .belowAverage:
                .orange
        case .average:
                .yellow
        case .aboveAverage:
                .accentColor
        case .good:
                .blue
        case .excellent:
                .green
        case .unknown:
                .gray
        }
    }
}

#Preview {
    let hkController = HKController()
    hkController.cardioFitnessMostRecent = 45
    hkController.cardioFitnessAverage = 44.2
    hkController.latestCardioFitness = .now

    return VO2Badge()
        .environment(hkController)
}
