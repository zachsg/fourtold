//
//  VO2Badge.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/6/24.
//

import SwiftUI

struct VO2Badge: View {
    @Bindable var healthKitController: HealthKitController

    var trend: FTVO2Trend {
        let vO2Average = healthKitController.cardioFitnessAverage
        let vO2Current = healthKitController.cardioFitnessMostRecent

        return vO2Current.vO2Trend(given: vO2Average)
    }

    var badgeParts: (main: Text, sub: Text, subJoiner: Text, image: Image) {
        let vO2Average = healthKitController.cardioFitnessAverage
        let vO2Current = healthKitController.cardioFitnessMostRecent
        let trend = vO2Current.vO2Trend(given: vO2Average)

        let main = Text(vO2Current.vO2Status().rawValue.capitalized)

        var sub: Text
        var subJoiner: Text
        var image: Image
        if trend == .declining {
            subJoiner = Text("but")
            sub = Text(trend.rawValue.capitalized)
            image = Image(systemName: decliningSystemImage)
        } else if trend == .improving {
            subJoiner = Text("and")
            sub = Text(trend.rawValue.capitalized)
            image = Image(systemName: improvingSystemImage)
        } else {
            subJoiner = Text("and")
            sub = Text(trend.rawValue.capitalized)
            image = Image(systemName: stableSystemImage)
        }

        return (main, sub, subJoiner, image)
    }

    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                badgeParts.main
                    .fontWeight(.bold)
                HStack(spacing: 4) {
                    badgeParts.subJoiner
                    badgeParts.sub
                        .fontWeight(.bold)
                }
            }

            badgeParts.image
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .foregroundStyle(trend == .improving ? .sweat : trend == .declining ? .yellow : .accent)
        }
        .foregroundStyle(.secondary)
        .font(.caption)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.cardioFitnessMostRecent = 44.5
    healthKitController.cardioFitnessAverage = 44.2
    healthKitController.latestCardioFitness = .now

    return VO2Badge(healthKitController: healthKitController)
}
