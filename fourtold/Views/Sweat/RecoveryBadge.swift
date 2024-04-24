//
//  RecoveryBadge.swift
//  fourtold
//
//  Created by Zach Gottlieb on 1/11/24.
//

import SwiftUI

struct RecoveryBadge: View {
    @Environment(HealthKitController.self) private var healthKitController

    var trend: FTRecoveryTrend {
        let recoveryAverage = healthKitController.recoveryAverage
        let recoveryCurrent = healthKitController.recoveryMostRecent

        return recoveryCurrent.recoveryTrend(given: recoveryAverage)
    }

    var badgeParts: Text {
        let recoveryAverage = healthKitController.recoveryAverage
        let recoveryCurrent = healthKitController.recoveryMostRecent
        let trend = recoveryCurrent.recoveryTrend(given: recoveryAverage)

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
                .rotationEffect(.degrees(trend == .improving ? 45 : trend == .worsening ? 135 : 90))
        }
        .foregroundStyle(.secondary)
        .font(.caption)
    }
}

#Preview {
    let healthKitController = HealthKitController()
    healthKitController.recoveryMostRecent = 36
    healthKitController.recoveryAverage = 32
    healthKitController.latestRecovery = .now

    return RecoveryBadge()
        .environment(healthKitController)
}
