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

    var badgeParts: (main: Text, sub: Text, image: Image) {
        let vO2Average = healthKitController.cardioFitnessAverage
        let vO2Current = healthKitController.cardioFitnessMostRecent
        let trend = vO2Current.vO2Trend(given: vO2Average)

        let main = Text(vO2Current.vO2Status().rawValue.capitalized)

        var sub: Text
        var image: Image
        if trend == .declining {
            sub = Text("but")
            image = Image(systemName: decliningSystemImage)
        } else if trend == .improving {
            sub = Text("and")
            image = Image(systemName: improvingSystemImage)
        } else {
            sub = Text("and")
            image = Image(systemName: stableSystemImage)
        }

        return (main, sub, image)
    }

    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                badgeParts.main
                    .fontWeight(.bold)
                badgeParts.sub
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
